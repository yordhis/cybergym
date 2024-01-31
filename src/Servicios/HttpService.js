//const RUTA_GLOBAL = "http://localhost/sistema-gimnasio-main/api/"
const RUTA_GLOBAL = `${window.location.protocol}//${window.location.host}/public/api/`;

console.log(RUTA_GLOBAL);

const HttpService = {
    async registrar(datos, ruta){
        const respuesta = await fetch(RUTA_GLOBAL + ruta, {
            method: "post",
            body: JSON.stringify(datos),
        });
        let resultado = await respuesta.json()
        return resultado
    },

    async obtenerConDatos(datos, ruta){
        const respuesta = await fetch(RUTA_GLOBAL + ruta, {
            method: "post",
            body: JSON.stringify(datos),
        });
        let resultado = await respuesta.json()
        return resultado
    },


    async obtener(ruta){
        let respuesta = await fetch(RUTA_GLOBAL + ruta)
        let datos = await respuesta.json()
        return datos
    },

    async eliminar(ruta, datos) {
        const respuesta = await fetch(RUTA_GLOBAL + ruta, {
            method: "post",
            body: JSON.stringify(datos),
        });
        let resultado = await respuesta.json()
        return resultado
    }

}

export default  HttpService 