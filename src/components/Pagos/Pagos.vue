<template>
    <div>
        <h1>Pagos <span class="indigo--text display-1"> ${{ totalPagos }}</span></h1>
        <periodo-busqueda @buscar="onBuscar"/>
        
        <v-card class="mt-3">
            <v-card-title>
                Pagos realizados: 
                <b v-if="!filtros.fechaInicio"> hoy</b>
                <b v-if="filtros.fechaInicio"> {{ filtros.fechaInicio }} al {{ filtros.fechaFin}}</b>
                <v-spacer></v-spacer>

                <v-text-field
                    v-model="busqueda"
                    append-icon="mdi-magnify"
                    label="Buscar"
                    single-line
                    hide-details
                ></v-text-field>

                <v-select
                v-model="busqueda"
                clearable
                
                label="Filtre por recepcionista"
                :items="recepcionistas"
                variant="solo-inverted"
                ></v-select>
            </v-card-title>

            <v-data-table
            :loading="cargando"
            :headers="encabezadoTabla"
            :items="pagos"
            :search="busqueda"
            sort-by="nombre"
            class="elevation-1"
            :footer-props="{itemsPerPageText: 'Por página'}"
            >
                
                <template v-slot:[`item.imagen`]="{ item }">
                    <v-avatar v-if="item.imagen">
                    <img
                        :src="urlImagen(item.imagen)"
                        alt="Foto"
                    >
                    </v-avatar>
                </template>

                <template slot="no-data">
                    <v-alert :value="true" color="error" icon="warning">
                        No se han encontrado datos.
                    </v-alert>
                    </template>
            </v-data-table>

            <v-btn
                color="success"
                class="my-2"
                @click="imprimirReporte"
            >
                IMPRIMIR REPORTE
            </v-btn>
           
        </v-card>

        <template v-if="rolUsuario == 'ADMINISTRADOR' ">

            <cartas-totales v-if="pagos.length > 0" :totales="totalesMembresias" :titulo="'Pagos realizados por membresía'" :icono="'mdi-currency-usd'" :color="'deep-orange darken-1'" />
    
            <cartas-totales v-if="pagos.length > 0" class="mt-3" :totales="totalesUsuarios" :titulo="'Pagos realizados por usuario'" :icono="'mdi-account-cash'" :color="'green darken-3'" />
    
            <cartas-totales-miembros v-if="pagos.length > 0" class="mt-3" :totales="totalesMiembros" :titulo="'Pagos realizados por miembros'"  />
        </template>

        <v-overlay :value="cargando">
            <v-progress-circular
                indeterminate
                size="64"
            ></v-progress-circular>
        </v-overlay>
    </div>
</template>
<script>
import HttpService from '../../Servicios/HttpService'
import Utiles from '../../Servicios/Utiles'
import PeriodoBusqueda from '../Dialogos/PeriodoBusqueda.vue'
import CartasTotales from '../Dialogos/CartasTotales.vue'
import CartasTotalesMiembros from '../Dialogos/CartasTotalesMiembros.vue'

export default {
    name: "Pagos",
    components: { PeriodoBusqueda, CartasTotales, CartasTotalesMiembros },
    data:()=>({
        busqueda: "",
        cargando: false,
        pagos: [],
        recepcionistas: [],
        encabezadoTabla: [
            {text: "Imagen", sortable: true, value: "imagen"},
            {text: "Miembro", sortable: true, value: "nombre"},
            {text: "Cédula", sortable: true, value: "cedula"},
            {text: "Fecha", sortable: true, value: "fecha"},
            {text: "Monto pagado", sortable: true, value: "monto"},
            {text: "Método de pago", sortable: true, value: "metodo_pago"},
            {text: "Membresía pagada", sortable: true, value: "membresia"},
            {text: "Cobró", sortable: true, value: "usuario"},
            ],
        filtros: {
            fechaInicio: null,
            fechaFin: null
        },
        totalPagos: 0,
        totalesMembresias: [],
        totalesUsuarios: [],
        totalesMiembros: [],
        rolUsuario: localStorage.getItem('rolUsuario')
    }),

    mounted(){
        this.obtenerPagos()
        this.obtenerRecepcionistas()
    },

    methods: {
        onBuscar(fechas){
            console.log(fechas)
            this.filtros = {
                fechaInicio: fechas[0],
                fechaFin: fechas[1]
            }

            this.obtenerPagos()
        },

        urlImagen(imagen){
            return Utiles.generarURL(imagen)
        },

        obtenerPagos(){
            this.cargando = true
            let payload = { 
                metodo: 'obtener',
                filtros: this.filtros
            }
            HttpService.obtenerConDatos(payload, 'pagos.php')
            .then(respuesta => {
                console.log(respuesta)
                this.pagos = respuesta.pagos
                this.totalPagos = respuesta.totalPagos
                this.totalesMembresias = respuesta.totalesMembresias
                this.totalesUsuarios = respuesta.totalesUsuario
                this.totalesMiembros = respuesta.totalesMiembros
                console.log(respuesta)
                this.cargando = false
            })

        },

        obtenerRecepcionistas(){
            const payload = { metodo: "get" };
            HttpService.obtenerConDatos(payload, "usuarios.php").then((resultado) => {
                console.log(resultado);
                resultado.forEach(recep => {
                    this.recepcionistas.push(recep.usuario);
                });
            });
        },

        /** TOMA EL ELEMENTO HTML PARA IMPRIMIR UN PDF O TIKCKET */
        imprimirElemento(elemento){
            var ventana = window.open('', 'PRINT', 'height=800,width=800');
            ventana.document.write('<html><head><title>Reporte de pagos</title>');
            ventana.document.write(`<style>
            * {
                margin-top: 0;
                font-size: 12px;
                font-family: 'Times New Roman';
            }

            body{
                margin: 0;
                position: relative;
                min-height: 100vh;
            }

            .img{
                width: 100px;
            }


            td,
            th,
            tr,
            table {
                padding: 2px;
                /* border-top: 1px solid rgb(27, 25, 25); */
                border-collapse: collapse;
                width: 60em;
            }

            th.titulo{
                font-size: 25px;
            }
            td.descripcion{
                padding: 5px;
                font-size: 10px;
                max-width: 150px;
            }

            th.numero,
            td.numero{
                padding: 5px;
                width: auto;
                max-width: 150px;
            }

            .table-totales{
                padding: 2px;
                position: absolute;
                bottom: 15em;
                width: 60em;
            }

            .text__left{
                text-align: left;
            }
            .text__right{
                text-align: right;
            }

            tr.border {
                border-top: 1px solid rgb(27, 25, 25);
                border-bottom: 1px solid rgb(27, 25, 25);
            }

            .red{
                color: brown;
            }

            .centrado {
                margin: 0%;
                text-align: center;
                align-content: center;
            }
            img {
                max-width: 100px;
                width: 100px;
                margin: 0%;
                margin-bottom: 0%;
                padding-left: 0%;
            }

            </style>`);
            ventana.document.write('</head><body >');
            ventana.document.write(elemento);
            ventana.document.write('</body></html>');
            ventana.document.close();
            ventana.focus();
            ventana.print();
            ventana.close();
            return true;
        },

        /** REPORTE DETALLADO DEL DIA */
        reporteHtml(reporte, config){
                
                let listaDeVentasDetallada = ``,
                subtotalBruto = 0;
             
                let fecha = new Date().toLocaleString('ves', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
                // hora = new Date(anio,mes-1,dia,hor,min,seg).toLocaleTimeString('ves');
              
                reporte.forEach(item => {
                    let [iAnio, iMes, iDia ] = item.fecha.split(" ")[0].split('-');
                    let dia = new Date(iAnio, iMes-1, iDia).toLocaleString('ves', { weekday: 'long' });

                    if(this.busqueda){
                        if(this.busqueda.toUpperCase() == item.usuario.toUpperCase()){
                            listaDeVentasDetallada += `
                                    <tr>
                                        <td class="text__left "> ${item.membresia}</td>
                                        <td class="text__left">  ${dia}</td>
                                        <td class="text__left ">${item.fecha.split(" ")[0]}</td>
                                        <td class="text__left ">
                                            ${item.nombre.toUpperCase()} <br> C.I.: ${item.cedula}
                                        </td>
                                        <td class="text__left">${item.usuario.toUpperCase()}</td>
                                        <td class="text__left">${item.metodo_pago}</td>
                                        <td class="text__right">${item.monto}</td>
                                    </tr> 
                            `;
                            subtotalBruto +=  parseFloat(item.monto);
                        }
                    }else{

                        listaDeVentasDetallada += `
                                <tr>
                                    <td class="text__left "> ${item.membresia}</td>
                                    <td class="text__left">  ${dia}</td>
                                    <td class="text__left ">${item.fecha.split(" ")[0]}</td>
                                    <td class="text__left ">
                                        ${item.nombre.toUpperCase()} <br> C.I.: ${item.cedula}
                                    </td>
                                    <td class="text__left">${item.usuario.toUpperCase()}</td>
                                    <td class="text__left">${item.metodo_pago}</td>
                                    <td class="text__right">${item.monto}</td>
                                </tr> 
                        `;
                        subtotalBruto +=  parseFloat(item.monto);
                    }

                });

                return `
                <table class="table">
                        <thead>
                            <tr>
                                <th colspan="1"><img src="${Utiles.generarURL(localStorage.getItem('logoGimnasio'))}" alt="logo" ></th>
                                <th colspan="6" class="text__left titulo">REPORTE DE PAGOS</th>
                            </tr>
                            <tr class="border">
                                <th colspan="3" class="text__left">
                                    QUIEN EMITIO EL REPORTE: ${localStorage.getItem('nombreUsuario').toUpperCase()}
                                </th>
                                <th colspan="4" class="text__right">TIPO DE REPORTE | 
                                    <span class="red">
                                        ${config.fechaFin ? 'POR RANGO DE FECHA' : 'DEL DÍA'}
                                    </span>
                                </th>
                            </tr>
                            <tr>
                                <th colspan="7" class="text__left">
                                    FECHA DE EMISIÓN DEL REPORTE:
                                </th>
                            </tr>
                            <tr>
                                <th colspan="7" class="text__left">
                                    ${fecha}
                                </th>
                            </tr>
                            <tr>
                                <th colspan="7" class="text__left">
                                    RANGO DE FECHA DEL REPORTE:
                                </th>
                            </tr>
                            <tr>
                                <th colspan="7" class="text__left">
                                    DE: ${config.fechaFin   ? config.fechaInicio + " HASTA: " + config.fechaFin 
                                                            : config.fechaInicio }
                                </th>
                            </tr>
                            <tr class="border">
                                <th class="text__left ">MEMBRESIA</th>
                                <th class="text__left">DÍA</th>
                                <th class="text__left ">FECHA</th>
                                <th class="text__left ">CLIENTE</th>
                                <th class="text__left ">RECEPCIONISTA</th>
                                <th class="text__left ">MÉTODO DE PAGO</th>
                                <th class="text__right ">SUBTOTAL</th>
                            </tr>
                        </thead>
                        <tbody>
                        
                           ${listaDeVentasDetallada}
                        </tbody>
                        <tfoot>
                            <tr class="border">
                                <td colspan="6" class="text__right">TOTAL: </td>
                                <td colspan="1" class="text__right">${subtotalBruto} USD</td>
                            </tr>
                        </tfoot>

                        
                    </table>
                `;
        },

        imprimirReporte(){
            console.log("imprimiendo reporte");
            console.log(this.busqueda)
            this.imprimirElemento(this.reporteHtml(this.pagos, this.filtros))

        }


    }
}
</script>