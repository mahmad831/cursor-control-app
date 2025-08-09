import cv2
import dlib
from scipy.spatial import distance as dist

class EyeTracker:
    def __init__(self):
        # Initialize dlib's face detector and facial landmark predictor
        self.detector = dlib.get_frontal_face_detector()
        self.predictor = dlib.shape_predictor("shape_predictor_68_face_landmarks.dat")
        self.points = [36, 37, 38, 39, 40, 41] # Right eye
        self.points.extend([42, 43, 44, 45, 46, 47]) # Left eye

    def get_gaze_direction(self, frame):
        # Convert frame to grayscale
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        
        # Detect faces in the grayscale frame
        rects = self.detector(gray, 0)
        
        if len(rects) > 0:
            # Assume only one face for simplicity
            shape = self.predictor(gray, rects[0])
            shape = self._shape_to_np(shape)
            
            # Get the coordinates of the eyes
            left_eye = shape[42:48]
            right_eye = shape[36:42]
            
            # Get the center of each eye
            left_eye_center = left_eye.mean(axis=0).astype("int")
            right_eye_center = right_eye.mean(axis=0).astype("int")

            # Determine gaze based on eye centers relative to face center
            face_center = np.mean([left_eye_center, right_eye_center], axis=0)
            
            # A simple heuristic for gaze direction
            if left_eye_center[0] < face_center[0] and right_eye_center[0] < face_center[0]:
                return "right"
            elif left_eye_center[0] > face_center[0] and right_eye_center[0] > face_center[0]:
                return "left"
            else:
                return "center"
        return "none"

    def _shape_to_np(self, shape, dtype="int"):
        # Convert dlib's shape object to a NumPy array
        coords = np.zeros((68, 2), dtype=dtype)
        for i in range(0, 68):
            coords[i] = (shape.part(i).x, shape.part(i).y)
        return coords

class BlinkDetector:
    def __init__(self):
        self.detector = dlib.get_frontal_face_detector()
        self.predictor = dlib.shape_predictor("shape_predictor_68_face_landmarks.dat")
        self.right_eye_start, self.right_eye_end = (36, 42)
        self.left_eye_start, self.left_eye_end = (42, 48)

    def is_blinking(self, frame):
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        rects = self.detector(gray, 0)
        
        if len(rects) > 0:
            shape = self.predictor(gray, rects[0])
            shape = self._shape_to_np(shape)
            
            left_eye = shape[self.left_eye_start:self.left_eye_end]
            right_eye = shape[self.right_eye_start:self.right_eye_end]
            
            left_ear = self._eye_aspect_ratio(left_eye)
            right_ear = self._eye_aspect_ratio(right_eye)
            
            avg_ear = (left_ear + right_ear) / 2.0
            
            # Check if eye aspect ratio is below a certain threshold
            return avg_ear < 0.25 # Threshold can be tuned

        return False
        
    def _eye_aspect_ratio(self, eye):
        A = dist.euclidean(eye[1], eye[5])
        B = dist.euclidean(eye[2], eye[4])
        C = dist.euclidean(eye[0], eye[3])
        ear = (A + B) / (2.0 * C)
        return ear

    def _shape_to_np(self, shape, dtype="int"):
        coords = np.zeros((68, 2), dtype=dtype)
        for i in range(0, 68):
            coords[i] = (shape.part(i).x, shape.part(i).y)
        return coords
