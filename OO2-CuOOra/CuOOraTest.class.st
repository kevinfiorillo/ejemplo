Class {
	#name : #CuOOraTest,
	#superclass : #TestCase,
	#instVars : [
		'sistema',
		'topic1',
		'topic2',
		'topic3',
		'user1',
		'user2',
		'user3',
		'ask1',
		'ask2',
		'ask3',
		'ans1',
		'ans2',
		'ans3'
	],
	#category : #'OO2-CuOOra-TestDeUnidad'
}

{ #category : #running }
CuOOraTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	|desc|

	sistema := CuOOra new.
	
	topic1 := 'Pharo'. desc := 'Entorno de desarrollo para smalltalk.'.
	topic1 := sistema agregarTopicoConNombre: topic1 descripcion: desc.
	topic2 := 'OO2'. desc := 'Orientación a objetos 2.'.
	topic2 := sistema agregarTopicoConNombre: topic2 descripcion: desc.
	topic3 := 'Info-UNLP'. desc := 'Facultad de Informática de la UNLP.'.
	topic3 := sistema agregarTopicoConNombre: topic3 descripcion: desc.
	
	user1 := sistema crearUnNuevoUsuarioConNombre: 'user1' contrasena: 'user1'.
	user2 := sistema crearUnNuevoUsuarioConNombre: 'user2' contrasena: 'user2'.
	user3 := sistema crearUnNuevoUsuarioConNombre: 'user3' contrasena: 'user3'.
	
	user1 agregarUsuarioParaSeguir: user2.
	user2 agregarUsuarioParaSeguir: user3.
	
	user1 agregarTopicoDeInteres: topic2.
	user2 agregarTopicoDeInteres: topic1.
	user3 agregarTopicoDeInteres: topic3.
	
	ask1 := '¿Cómo se usa Pharo?'. desc := 'Lo instale y no funciona.'.
	ask1 := sistema agregarPreguntaConTopicos: { topic1. topic2. } titulo: ask1 descripcion: desc usuario: user2.
	ask1 agregarLikeDelUsuario: user1.
	ask1 agregarLikeDelUsuario: user3.
	desc := 'Hay que leer el manual.'.
	ans1 := sistema agregarRespuestaParaLaPregunta: ask1 texto: desc usuario: user1.

	ask2 := '¿Dónde esta el centro de estudiantes?'. desc := 'No lo encuentro en el mapa.'.
	ask2 := sistema agregarPreguntaConTopicos: { topic3. } titulo: ask1 descripcion: desc usuario: user2.
	ask2 agregarDislikeDelUsuario: user3.
	ask2 agregarLikeDelUsuario: user1.
	desc := 'Pregunta en la fotocopiadora.'.
	ans2 := sistema agregarRespuestaParaLaPregunta: ask2 texto: desc usuario: user3.
	
	ask3 := '¿Cual es la diferencia entre herencia y composición?'. desc := 'Aprobe Taller, AyED, OO1 y sigo sin entender.'.
	ask3 := sistema agregarPreguntaConTopicos: { topic2. } titulo: ask3 descripcion: desc usuario: user3.
	ask3 agregarDislikeDelUsuario: user1.
	ask3 agregarDislikeDelUsuario: user2.
	desc := 'jajajaja'.
	ans3 := sistema agregarRespuestaParaLaPregunta: ask3 texto: desc usuario: user1.
	ans3 agregarLikeDelUsuario: user2.
	
]

{ #category : #tests }
CuOOraTest >> testAgregarPreguntaConTopicosTituloDescripcionUsuario [
	"Se verifica la correcta creación de una pregunta."

	|ask|
	
	ask := sistema agregarPreguntaConTopicos: { topic1. } titulo: 'Test' descripcion: 'testing...' usuario: user1.
	
	self assert: (sistema tenesLaPregunta: ask).
	self assert: ask titulo equals: 'Test'.
	self assert: ask descripcion equals: 'testing...'.
	self assert: ask usuario equals: user1.
]

{ #category : #tests }
CuOOraTest >> testAgregarRespuestaParaLaPreguntaTextoUsuario [
	"Se veriifca la correcta creación de una respuesta."

	|ans|
	
	ans := sistema agregarRespuestaParaLaPregunta: ask1 texto: 'Test' usuario: user3.
	
	self assert: (ask1 tenesLaRespuesta: ans).
	self assert: ans texto equals: 'Test'.
	self assert: ans usuario equals: user3.
]

{ #category : #tests }
CuOOraTest >> testAgregarTopicoConNombreDescripcion [
	"Se verifica la correcta creación de un tópico."

	|topic|
	
	topic := sistema agregarTopicoConNombre: 'Test' descripcion: 'Desc'.
	
	self assert: (sistema tenesElTopico: topic).
	self assert: topic nombre equals: 'Test'.
	self assert: topic descripcion equals: 'Desc'.
]

{ #category : #tests }
CuOOraTest >> testAgregarTopicoDeInteresParaElUsuario [
	"Se verifica la correcta adición de un tópico."

	|topicos|	
	sistema agregarTopicoDeInteres: topic1 paraElUsuario: user1.
	topicos := user1 topicos.
	
	self assert: (topicos includes: topic1).

	
]

{ #category : #tests }
CuOOraTest >> testBorrarLaPregunta [
	"Se verifica la correcta eliminación de una pregunta."

	|preguntas borrada|
	
	preguntas := sistema preguntas.
	borrada := sistema borrarLaPregunta: ask1.
	
	self deny: (preguntas includes: ask1).
	self deny: (preguntas includes: borrada).
	self assert: borrada equals: ask1.
]

{ #category : #tests }
CuOOraTest >> testCrearUnNuevoUsuarioConNombreContrasena [
	"Se verifica la correcta creación de un nuevo usuario."
	
	|usuarios user|
	
	usuarios := sistema usuariosSeguidos.
	user := sistema crearUnNuevoUsuarioConNombre: 'Test' contrasena: 'pass'.
	
	self assert: (usuarios includes: user).
	self assert: user nombre equals: 'Test'.
	self assert: user contrasena equals: 'pass'.
]

{ #category : #tests }
CuOOraTest >> testObtenerLasPreguntasConElTopico [
	"Se verifica la correcta obetención de una colección de preguntas que contienen un determinado tópico."

	|preguntas|

	preguntas := sistema obtenerLasPreguntasConElTopico: topic1.
	self assert: preguntas size equals: 1.
	self assert: (preguntas allSatisfy: [ :p | p tieneElTopico: topic1. ]).

	preguntas := sistema obtenerLasPreguntasConElTopico: topic2.
	self assert: preguntas size equals: 2.
	self assert: (preguntas allSatisfy: [ :p | p tieneElTopico: topic2. ]).

	preguntas := sistema obtenerLasPreguntasConElTopico: topic3.
	self assert: preguntas size equals: 1.
	self assert: (preguntas allSatisfy: [ :p | p tieneElTopico: topic3. ]).
]

{ #category : #tests }
CuOOraTest >> testObtenerPreguntasRelevantesParaElUsuario [
	"Se verifica la correcta obtención de una colección de preguntas que son relevantes para un usuario determinado."

	|preguntas|
	
	preguntas := sistema obtenerPreguntasRelevantesParaElUsuario: user1.
	self assert: (preguntas includes: ask1).
	self assert: (preguntas includes: ask2).
	self assert: (preguntas includes: ask3).
	
	preguntas := sistema obtenerPreguntasRelevantesParaElUsuario: user2.
	self assert: (preguntas includes: ask1).
	self deny: (preguntas includes: ask2).
	self assert: (preguntas includes: ask3).

]

{ #category : #tests }
CuOOraTest >> testObtenerPuntajeDelUsuario [

	"Se verifica el correcto cálculo de puntaje de un usuario determinado."

	|user|
	user := sistema crearUnNuevoUsuarioConNombre: 'Test' contrasena: 'Test'.
	self assert: (sistema obtenerPuntajeDelUsuario: user1) equals: 101.
	self assert: (sistema obtenerPuntajeDelUsuario: user2) equals: 42.
	self assert: (sistema obtenerPuntajeDelUsuario: user3) equals: 68.
	self assert: (sistema obtenerPuntajeDelUsuario: user) equals: 0.
	
]

{ #category : #tests }
CuOOraTest >> testObtenerRespuestasDeLaPregunta [
	"Se verifica la correcta creación de una respuesta para una pregunta determinada."
	|respuestas ans|

	ans := ask1 crearRespuestaConTexto: 'Test' usuario: user1.	
	respuestas := sistema obtenerRespuestasDeLaPregunta: ask1.
	self assert: respuestas size equals: 2.
	self assert: (respuestas includes: ans1).
	self deny: (respuestas includes: ans2).
	self deny: (respuestas includes: ans3).
	self assert: (respuestas includes: ans).
]

{ #category : #tests }
CuOOraTest >> testPreguntasDelUsuario [
	"se verifica la correcta obtención de una colección cuyo contenido son todas las preguntas realizadas por un usuario determinado."
	|preguntas|
	
	preguntas := sistema preguntasDelUsuario: user1.
	self assert: preguntas isEmpty.
	preguntas := sistema preguntasDelUsuario: user2.
	self assert: preguntas size equals: 2.
	self assert: (preguntas includes: ask1).
	self assert: (preguntas includes: ask2).
	self deny: (preguntas includes: ask3).

]

{ #category : #tests }
CuOOraTest >> testRespuestasDelUsuario [
	"Se verifica la correcta obtención de una colección cuyo contenid son todas las respuestas realizadas por un usuario determinado."

	|respuestas|
	
	respuestas := sistema respuestasDelUsuario: user1.
	self assert: respuestas size equals: 2.
	self assert: (respuestas includes: ans1).
	self deny: (respuestas includes: ans2).
	self assert: (respuestas includes: ans3).
	
]
