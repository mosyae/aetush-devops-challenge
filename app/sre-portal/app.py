from flask import Flask, render_template, jsonify
import os
import socket
from datetime import datetime
import time

app = Flask(__name__)

# Store startup time
START_TIME = time.time()

@app.route('/')
def index():
    """Main dashboard page"""
    return render_template('index.html')

@app.route('/api/info')
def get_info():
    """Get pod and system information"""
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

@app.route('/action', methods=['POST'])
def action():
    """Action endpoint triggered by button"""
    return jsonify({
        'status': 'success',
        'message': 'Action executed successfully',
        'pod_name': os.getenv('HOSTNAME', socket.gethostname()),
        'timestamp': datetime.utcnow().isoformat()
    }), 200

@app.route('/metrics')
def metrics():
    """Prometheus-style metrics endpoint"""
    uptime = int(time.time() - START_TIME)
    return f"""# HELP app_uptime_seconds Application uptime in seconds
# TYPE app_uptime_seconds gauge
app_uptime_seconds {uptime}

# HELP app_info Application information
# TYPE app_info gauge
app_info{{pod_name="{os.getenv('HOSTNAME', socket.gethostname())}"}} 1
""", 200, {'Content-Type': 'text/plain'}

if __name__ == '__main__':
    port = int(os.getenv('PORT', 3000))
    app.run(host='0.0.0.0', port=port, debug=False)
