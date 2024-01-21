<template>
    <div>
        <h1>Nombre del usuario: {{ nombreUsuario }}</h1>
        <h3>Rol:{{ rolUsuario }}</h3>
         <v-btn
        depressed
        class="my-3"
        color="primary"
        @click="cambiarPassword">
        Cambiar contraseña
        </v-btn>

    
       
<!-- 
        <template v-if="rolUsuario == 'ADMINISTRADOR' ">
            <cartas-personalizadas :cartas="datosPagos" />
        </template > -->
            
    </div>
</template>
<script>
import HttpService from '../../Servicios/HttpService'
import CartasPersonalizadas from '../Dialogos/CartasPersonalizadas.vue'

export default {
    name: "MiPerfil",
    components: { CartasPersonalizadas },
    
    data:()=>({
        nombreUsuario: localStorage.getItem('nombreUsuario'),
        rolUsuario: localStorage.getItem('rolUsuario'),
        datosVisitas: [],
        datosPagos: [],
    }),

    mounted(){
        this.obtenerInformacion()
    },

    methods: {
        cambiarPassword(){
            this.$router.push( { name: 'CambiarPassword' })
        },

        obtenerInformacion(){
            HttpService.obtenerConDatos({
                metodo: 'informacion_perfil',
                idUsuario: localStorage.getItem('idUsuario')
            }, 'usuarios.php')
            .then(resultado => {
                console.log(resultado);
                this.crearCartas(resultado.datosPagos)
            })
        },

        crearCartas(pagos){
         
            this.datosPagos = [
                { color: 'blue darken-1', icono: 'mdi-currency-usd', nombre: 'Total pagos', total: '$' + pagos.totalPagos},
                { color: 'teal darken-1', icono: 'mdi-calendar', nombre: 'Pagos hoy', total: '$' + pagos.pagosHoy},
                { color: 'green darken-1', icono: 'mdi-calendar-range', nombre: 'Pagos semana', total: '$' + pagos.pagosSemana},
                { color: 'orange darken-1', icono: 'mdi-calendar-month', nombre: 'Pagos mes', total: '$' + pagos.pagosMes},
            ]
        }
    }
}
</script>