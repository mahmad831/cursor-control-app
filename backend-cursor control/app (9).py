from flask import Flask, request, jsonify
import numpy as np
import cv2
import base64
from eye_tracker import EyeTracker, BlinkDetector

app = Flask(__name__)
eye_tracker = EyeTracker()
blink_detector = BlinkDetector()

@app.route('/track', methods=['POST'])
def track():
    data = request.json
    frame_data = data['frame']
    
    # Decode the base64 image data
    img_bytes = base64.b64decode(frame_data)
    img_np = np.frombuffer(img_bytes, np.uint8)
    frame = cv2.imdecode(img_np, cv2.IMREAD_COLOR)

    if frame is None:
        return jsonify({'error': 'Failed to decode image'}), 400
    
    # Process the frame for eye and blink detection
    gaze_direction = eye_tracker.get_gaze_direction(frame)
    is_blinking = blink_detector.is_blinking(frame)

    # Convert results to JSON
    return jsonify({
        'gaze_direction': gaze_direction,
        'is_blinking': is_blinking
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
