REQUERIMIENTOS

1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo
pedido.

postgres=# CREATE DATABASE desafio3_cristian_arevalo_777;

postgres=# \c desafio3_cristian_arevalo_777;

CREANDO LA TABLA USUARIOS 
desafio3_cristian_arevalo_777=#  CREATE TABLE usuarios (id SERIAL PRIMARY KEY, email VARCHAR (30), nombre VARCHAR, apellido VARCHAR, rol VARCHAR);

desafio3_cristian_arevalo_777=# INSERT INTO usuarios (email, nombre, apellido, rol) VALUES ('qwerty@lalal.cl', 'Jose', 'Garcia', 'Admin'), ('asdf@lala.cl', 'Pepito', 'Perez', 'User'), ('zxcv@lala.cl', 'Carolina', 'Muñoz', 'User'), ('poiu@lala.cl', 'Pedro', 'Hernandez', 'User'), ('ñlkj@lala.cl', 'Miguel', 'Flores', 'User');

CREANDO LA TABLA POSTS
CREATE TABLE posts (id SERIAL PRIMARY KEY, titulo VARCHAR, contenido TEXT, fecha_creacion TIMESTAMP, fecha_actualizacion TIMESTAMP, destacado BOOL, usuario_id B
IGINT);

INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES ('titulo1', 'contenido1', '2018/02/02 20:30:30', '2018/02/25 10:30:40', true, 1), ('titulo2', 'contenido2', '2018/02/17 21:30:30', '2018/03/25 08:30:40', false, 1), ('titulo3', 'contenido3', '2018/04/17 14:30:30', '2018/05/25 10:30:40', false, 2), ('titulo4', 'contenido4', '2018/03/15 09:30:30', '2018/04/20 12:30:40', true, 2), ('titulo5', 'contenido5', '2019/02/17 08:30:30', '2019/03/25 10:30:40', false, null) 

CREANDO LA TABLA COMENTARIOS
CREATE TABLE comentarios (id SERIAL PRIMARY KEY, contenido TEXT,
 fecha_creacion TIMESTAMP, usuario_id BIGINT, post_id BIGINT);

 INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES ('comentario1', '2018/02/25 12:30:40', 1, 1), ('comentario2', '2018/03/25 10:30:40', 2, 1), ('comentario3', '2018/05/25 12:30:40', 3, 1), ('comentario4', '2018/06/25 12:30:40', 1, 2), ('comentario5', '2018/07/25 12:30:40', 2, 2);


2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
nombre y email del usuario junto al título y contenido del post.

SELECT usuarios.nombre, usuarios.email, posts.titulo, posts.contenido FROM usuarios JOIN posts ON usuarios.id = posts.usuario_id;

3. Muestra el id, título y contenido de los posts de los administradores.
a. El administrador puede ser cualquier id.

SELECT posts.id, posts.contenido, posts.titulo FROM posts JOIN usuarios ON posts.usuario_id = usuarios.id WHERE usuarios.rol = 'Admin';

4. Cuenta la cantidad de posts de cada usuario.
a. La tabla resultante debe mostrar el id e email del usuario junto con la
cantidad de posts de cada usuario.

SELECT usuarios.id, usuarios.email, COUNT(posts.id) AS post_count FROM usuarios LEFT JOIN posts ON usuarios.id = posts.usuario_id GROUP BY usuarios.id ORDER BY post_count ASC;

5. Muestra el email del usuario que ha creado más posts.
a. Aquí la tabla resultante tiene un único registro y muestra solo el email.

WITH User_Post_Count AS ( SELECT usuarios.email, COUNT(posts.id) AS post_count FROM usuarios JOIN posts ON usuarios.id = posts.usuario_id GROUP BY usuarios.email) SELECT email FROM (SELECT email, RANK() OVER (ORDER BY post_count DESC) AS rnk FROM User_Post_Count) AS ranked WHERE rnk = 1;

6. Muestra la fecha del último post de cada usuario.

SELECT usuarios.nombre, MAX(posts.fecha_creacion) AS latest_post_date FROM usuarios JOIN posts ON usuarios.id = posts.usuario_id GROUP BY usuarios.nombre;

7. Muestra el título y contenido del post (artículo) con más comentarios.

WITH commentCounts AS (SELECT post_id, COUNT (id) AS comment_count FROM comentarios GROUP BY post_id) SELECT posts.titulo, posts.contenido FROM posts JOIN (SELECT post_id, RANK () OVER (ORDER BY comment_count DESC) AS rnk FROM commentCounts) AS ranked_comments ON posts.id = ranked_comments.post_id WHERE rnk = 1;

8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
de cada comentario asociado a los posts mostrados, junto con el email del usuario
que lo escribió.

SELECT posts.titulo AS post_titulo, posts.contenido AS post_contenido, comentarios.contenido AS comentario_contenido, usuarios.email FROM posts JOIN comentarios ON posts.id = comentarios.post_id JOIN usuarios ON comentarios.usuario_id = usuarios.id;

9. Muestra el contenido del último comentario de cada usuario.

SELECT MAX(comentarios.fecha_creacion) AS fecha_creacion, comentarios.contenido AS comentario_contenido, usuarios.id AS usuario_id FROM usuarios JOIN comentarios ON comentarios.usuario_id = usuarios.id WHERE comentarios.fecha_creacion = ( SELECT MAX(c.fecha_creacion) FROM comentarios c WHERE c.usuario_id = usuarios.id ) GROUP BY usuarios.id, comentarios.contenido;

10. Muestra los emails de los usuarios que no han escrito ningún comentario.

SELECT usuarios.email FROM usuarios LEFT JOIN comentarios ON comentarios.usuario_id = usuarios.id WHERE comentarios.usuario_id IS NULL;