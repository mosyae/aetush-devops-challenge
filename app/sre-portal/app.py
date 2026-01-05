from flask import Flask, render_template, jsonify
import os
import socket
from datetime import datetime
import time
from prometheus_flask_exporter import PrometheusMetrics
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = Flask(__name__)
metrics = PrometheusMetrics(app)

# Store startup time
START_TIME = time.time()

@app.route('/')
def index():
    """Main dashboard page"""
    logger.info("Dashboard page accessed")
    return render_template('index.html')

@app.route('/api/info')
def get_info():
    """Get pod and system information"""
    try:
        uptime_seconds = int(time.time() - START_TIME)
        hours, remainder = divmod(uptime_seconds, 3600)
        minutes, seconds = divmod(remainder, 60)
        
        return jsonify({
            'hostname': socket.gethostname(),
            'pod_name': os.getenv('HOSTNAME', socket.gethostname()),
            'uptime': f"{hours}h {minutes}m {seconds}s",
            'uptime_seconds': uptime_seconds,
            'timestamp': datetime.utcnow().isoformat()
        })
    except Exception as e:
        logger.error(f"Error getting system info: {str(e)}", exc_info=True)
        return jsonify({'error': 'Internal Server Error'}), 500

@app.route('/health')
def health():
    """Health check endpoint for Kubernetes liveness probe"""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.utcnow().isoformat()
    }), 200

@app.route('/readiness')
def readiness():
    """Readiness check endpoint for Kubernetes readiness probe"""
    # Add any readiness checks here (DB connection, etc.)
    return jsonify({
        'status': 'ready',
        'timestamp': datetime.utcnow().isoformat()
    }), 200

import random

@app.route('/action', methods=['POST'])
def action():
    """Action endpoint triggered by button"""
    try:
        # Simulate random 500 errors (20% chance) for monitoring demonstration
        if random.random() < 0.2:
            raise Exception("Random chaos error occurred!")

        pod_name = os.getenv('HOSTNAME', socket.gethostname())
        logger.info(f"Action triggered on pod {pod_name}")

        return jsonify({
            'status': 'success',
            'message': 'Action executed successfully',
            'pod_name': pod_name,
            'timestamp': datetime.utcnow().isoformat()
        }), 200
    except Exception as e:
        logger.exception("Failed to execute action")
        return jsonify({'status': 'error', 'message': str(e)}), 500

if __name__ == '__main__':
    port = int(os.getenv('PORT', 3000))
    app.run(host='0.0.0.0', port=port, debug=False)
