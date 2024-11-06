
class Actividad {
  const property idiomas = []
  method esInteresante() = idiomas.size() > 1 

  method sirveParaBroncearse() = true

  method dias()
  method esRecomendada(unSocio) = self.esInteresante() and unSocio.leAtrae(self) and not unSocio.actividades().contains(self)
}

class ViajeDePlaya inherits Actividad {
  const largo

  method implicaEsfuerzo() = largo > 1200
  
  override method dias() = largo / 500
}

class ExcursionACiudad inherits Actividad {
  var property cantidadAtracciones 
  override method dias() = cantidadAtracciones / 2
  method implicaEsfuerzo() = cantidadAtracciones.between(5, 8)
  override method sirveParaBroncearse() = false

  override method esInteresante() = super() || cantidadAtracciones == 5
}

class ExcursionTropical inherits ExcursionACiudad {
  override method dias() = super() + 1
  override method sirveParaBroncearse() = true
}

class SalidaDeTrekking inherits Actividad {
  const kmDeSenderos
  const diasDeSolAlAno

  override method dias() = kmDeSenderos / 50
  method implicaEsfuerzo() = kmDeSenderos > 80
  
  override method sirveParaBroncearse(){
  return diasDeSolAlAno > 200 || (diasDeSolAlAno.between(100, 200) && kmDeSenderos > 120)
  }

  override method esInteresante() = super() && diasDeSolAlAno > 140
}

class ClaseDeGimnasia inherits Actividad {
  method initialize(){
    idiomas.clear()
    idiomas.add("español")
  
  if(idiomas!=["español"]) self.error("solo se permite español")
  }
  override method dias() = 1
  method implicaEsfuerzo() = true
  override method sirveParaBroncearse() = false
  override method esRecomendada(unSocio) = unSocio.edad().between(20, 30)
}

class TallerLiterario inherits Actividad{
  const libros =#{}
  method initialize(){
    idiomas.clear()
    idiomas.addAll(libros.map({libro => libro.idioma()}))
  }
  override method dias() = libros.size() + 1

  method implicaEsfuerzo() = libros.any({libro => libro.cantidadDePaginas() > 500 })
  or (libros.size() > 1 and libros.map({libro => libro.nombreDelAutor()}).asSet().size() == 1)

  override method sirveParaBroncearse() = false

  override method esRecomendada(unSocio) = unSocio.idiomas().size() > 1  
}

class Libro{
  const property idioma
  const property cantidadDePaginas
  const property nombreDelAutor
}

class Socio {
  const property actividades = []
  const maximoActividades
  var property edad
  const property idiomas = #{}

  method esAdoradorDelSol() = actividades.all({actividades => actividades.sirveParaBroncearse()})
  method actividadesEsforzadas() = actividades.filter({actividades => actividades.implicaEsfuerzo()})
  method registrarActividad(unaActividad) {
    if(maximoActividades == actividades.size()) self.error("alcanzo el maximo de actividades")
      actividades.add(unaActividad)}
  method leAtrae(unaActividad)
}

class SocioTranquilo inherits Socio{
  override method leAtrae(unaActividad) = unaActividad.dias() >= 4
}

class SocioCoherente inherits Socio {
  override method leAtrae(unaActividad){
    return
      if(self.esAdoradorDelSol()) unaActividad.sirveParaBroncearse()
      else unaActividad.implicaEsfuerzo()
  }
}

class SocioRelajado inherits Socio {
  override method leAtrae(unaActividad) {
    return 
      not idiomas.intersection(unaActividad.idiomas().isEmpty())
  }
}