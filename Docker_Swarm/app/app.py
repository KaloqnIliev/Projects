from flask import Flask, request, jsonify
from flask_mysqldb import MySQL

app = Flask(__name__)

app.config['MYSQL_HOST'] = 'db' 
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'password'
app.config['MYSQL_DB'] = 'Users'

mysql = MySQL(app)

@app.route('/users', methods=['GET', 'POST'])
def users():
    if request.method == 'POST':
        user_details = request.get_json()
        name = user_details['name']
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO users(name) VALUES (%s)", [name])
        mysql.connection.commit()
        return jsonify({'response' : 'User added successfully!'})
    else:
        cur = mysql.connection.cursor()
        response = cur.execute("SELECT * FROM users")
        if response > 0:
            users = cur.fetchall()
            return jsonify(users)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
