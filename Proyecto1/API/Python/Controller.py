import mysql.connector
from dotenv import load_dotenv
import csv
import os

# Carga las variables de entorno desde el archivo .env
load_dotenv()

class Controller:
    def __init__(self) -> None:
        self.conexion = mysql.connector.connect(
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASS'),
            host=os.getenv('DB_HOST'),
            port=os.getenv('DB_PORT'),
            database=os.getenv('DB_NAME'),
        )
        print(os.getenv('DB_USER'))
        self.cursor = self.conexion.cursor()

    def deletemodel(self):
        try:
            query = f'''DROP TABLE IF EXISTS orden;
            DROP TABLE IF EXISTS datoorden;
            DROP TABLE IF EXISTS producto;
            DROP TABLE IF EXISTS vendedor;
            DROP TABLE IF EXISTS cliente;
            DROP TABLE IF EXISTS categoria;
            DROP TABLE IF EXISTS pais;'''
            for q in query.split('\n'):
                self.cursor.execute(q)
            return {'status': 'Modelo eliminado'}, 200
        except Exception as e:
            print(e)
            return {'status': 'Error al eliminar modelo'}, 500

    def createmodel(self):
        try:
            query = open('../../Script/BD1P1.sql').read()
            for q in query.split(';'):
                self.cursor.execute(q)
            return {'status': 'Modelo creado'}, 200
        except Exception as e:
            print(e)
            return {'status': 'Error al crear modelo'}, 500

    def deleteinfo(self):
        try:
            query = f'''SET FOREIGN_KEY_CHECKS = 0;
            TRUNCATE TABLE orden;
            TRUNCATE TABLE datoorden;
            TRUNCATE TABLE producto;
            TRUNCATE TABLE vendedor;
            TRUNCATE TABLE cliente;
            TRUNCATE TABLE categoria;
            TRUNCATE TABLE pais;
            SET FOREIGN_KEY_CHECKS = 1;'''
            for q in query.split('\n'):
                self.cursor.execute(q)
            return {'status': 'Informacion eliminada'}, 200
        except Exception as e:
            print(e)
            return {'status': 'Error al eliminar informacion'}, 500

    def postdatamodel(self):
        try:
            files = {
                0: '../../Data/paises.csv',
                1: '../../Data/Categorias.csv',
                2: '../../Data/clientes.csv',
                3: '../../Data/vendedores.csv',
                4: '../../Data/productos.csv',
                5: '../../Data/ordenes.csv',
            }

            for i, r in files.items():
                file = open(r, newline='', encoding='utf-8')
                reader = csv.reader(file, delimiter=';')
                next(reader, None)

                for line in reader:
                    if i == 0:
                        self.cursor.execute(f'''INSERT INTO pais (id, nombre) VALUE ({line[0]}, "{line[1]}")''')
                        self.conexion.commit()
                    elif i == 1:
                        self.cursor.execute(f'''INSERT INTO categoria (id, nombre) VALUE ({line[0]}, "{line[1]}")''')
                        self.conexion.commit()
                    elif i == 2:
                        self.cursor.execute(f'''INSERT INTO cliente (id, nombre, apellido, direccion, telefono, tarjeta, edad, salario, genero, pais_id) VALUE ({line[0]}, "{line[1]}", "{line[2]}", "{line[3]}", "{line[4]}", "{line[5]}", {line[6]}, {line[7]}, "{line[8]}", {line[9]})''')
                        self.conexion.commit()
                    elif i == 3:
                        fullName = line[1].split(" ")
                        self.cursor.execute(f'''INSERT INTO vendedor (id, nombre, apellido, pais_id) VALUE ({line[0]}, "{fullName[0]}", "{fullName[1]}", {line[2]})''')
                        self.conexion.commit()
                    elif i == 4:
                        self.cursor.execute(f'''INSERT INTO producto (id, nombre, precio, categoria_id) VALUE ({line[0]}, "{line[1]}", {line[2]}, {line[3]})''')
                        self.conexion.commit()
                    else:
                        date = line[2].split("/")
                        line[2] = f"{date[2]}-{date[1]}-{date[0]}"
                        self.cursor.execute(f'''INSERT INTO orden (id, fecha, cliente_id) SELECT {line[0]}, '{line[2]}', {line[3]} FROM orden WHERE id != {line[0]}''')
                        self.cursor.execute(f'''INSERT INTO datoorden (linea, cantidad, orden_id, vendedor_id, producto_id) VALUE ({line[1]}, {line[6]}, {line[0]}, {line[4]}, {line[5]})''')
                        self.conexion.commit()

            return {'status': 'Informacion insertada'}, 200
        except Exception as e:
            print(e)
            return {'status': 'Error al insertar informacion'}, 500