from Controller import Controller
from flask import Flask
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

ctrlr = Controller()

@app.route('/', methods=['GET'])
def running():
    return {'status': 'Server is running!!!'}

@app.route('/consulta1', methods=['GET'])
def query1():
    return {'status': 'Query1'}

@app.route('/consulta2', methods=['GET'])
def query2():
    return {'status': 'Query2'}

@app.route('/consulta3', methods=['GET'])
def query3():
    return {'status': 'Query3'}

@app.route('/consulta4', methods=['GET'])
def query4():
    return {'status': 'Query4'}

@app.route('/consulta5', methods=['GET'])
def query5():
    return {'status': 'Query5'}

@app.route('/consulta6', methods=['GET'])
def query6():
    return {'status': 'Query6'}

@app.route('/consulta7', methods=['GET'])
def query7():
    return {'status': 'Query7'}

@app.route('/consulta8', methods=['GET'])
def query8():
    return {'status': 'Query8'}

@app.route('/consulta9', methods=['GET'])
def query9():
    return {'status': 'Query9'}

@app.route('/consulta10', methods=['GET'])
def query10():
    return {'status': 'Query10'}

@app.route('/eliminarmodelo', methods=['GET'])
def deletemodel():
    return ctrlr.deletemodel()

@app.route('/crearmodelo', methods=['GET'])
def createmodel():
    return ctrlr.createmodel()

@app.route('/borrarinfodb', methods=['GET'])
def deleteinfo():
    return ctrlr.deleteinfo()

@app.route('/cargarmodelo', methods=['GET'])
def postdatamodel():
    return ctrlr.postdatamodel()

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug = True, port = 8000)