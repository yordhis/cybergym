<template>
    <div>
        <h1>Pagos <span class="indigo--text display-1"> ${{ totalPagos }}</span></h1>
        <periodo-busqueda @buscar="onBuscar"/>
        
        <cartas-totales v-if="pagos.length > 0" :totales="totalesMembresias" :titulo="'Pagos realizados por membresía'" :icono="'mdi-currency-usd'" :color="'deep-orange darken-1'" />
        
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
        <cartas-totales v-if="pagos.length > 0" class="mt-3" :totales="totalesUsuarios" :titulo="'Pagos realizados por usuario'" :icono="'mdi-account-cash'" :color="'green darken-3'" />

        <cartas-totales-miembros v-if="pagos.length > 0" class="mt-3" :totales="totalesMiembros" :titulo="'Pagos realizados por miembros'"  />

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
        totalesMiembros: []
    }),

    mounted(){
        this.obtenerPagos()
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

        /** TOMA EL ELEMENTO HTML PARA IMPRIMIR UN PDF O TIKCKET */
        imprimirElemento(elemento){
            var ventana = window.open('', 'PRINT', 'height=400,width=600');
            ventana.document.write('<html><head><title>Reporte</title>');
            ventana.document.write(`<style>
        * {
            margin-top: 0%;
            font-size: 10px;
            font-family: 'Times New Roman';
        }

        .img{
            width: 100px;
        }


        td,
        th,
        tr,
        table {
            padding: 5px;
            /* border-top: 1px solid rgb(27, 25, 25); */
            border-collapse: collapse;
        }

        th.titulo{
            text-align: left;
            font-size: 16px;
        }

        tr.border {
            border-top: 1px solid rgb(27, 25, 25);
            border-bottom: 1px solid rgb(27, 25, 25);
        }
        
        td.descripcion,
        th.descripcion {
            text-align: left;
            width: auto;
            max-width: 350px;
        
        }
        td.descripcion-producto,
        th.descripcion-producto {
            font-size: 11px;
            text-align: left;
            width: auto;
            max-width: 350px;
        }
        td.descripcion-num,
        th.descripcion-num {
            font-size: 11px;
            text-align: right;
            width: auto;
        }
        


        td.numero,
        th.numero {
            text-align: right;
            font-size: 14px;
        }

        td.total-bruto{
            text-align: right;
        }
        td.total-neto{
            text-align: right;
        }
        /* 

        td.precio,
        th.precio {
            font-size: 18px;
            width: 160px;
            max-width: 160px;
            word-break: break-all;
            text-align: right;
        } */

        .centrado {
            margin: 0%;
            text-align: center;
            align-content: center;
        }

        .ticket {
            width: 325px;
            max-width: 355px;
        }

        img {
            max-width: 150px;
            width: 150px;
            margin-top: 3%;
            margin-bottom: 0%;
            padding-left: 28%;
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

                    listaDeVentasDetallada += `
                        <tr>
                            <td> ${item.membresia} </td>
                            <td class="descripcion-producto"> ${dia} </td>
                            <td class="numero">${item.fecha.split(" ")[0]}</td>
                            <td class="numero">${item.nombre} <br> C.I.: ${item.cedula}</td>
                            <td class="numero">${item.metodo_pago}</td>
                            <td class="numero">${item.monto}</td>
                        </tr>
                    `;

                    subtotalBruto +=  parseFloat(item.monto);
                   
                });

                return `
                <table class="table">
                    <thead>
                        <tr>

                            <th colspan="8" class="titulo">
                                REPORTE
                            </th>
                        </tr>
                        <tr>
                            <th colspan="4" class="descripcion">
                                FECHA DE EMISIÓN DEL REPORTE: <br> 
                                ${config.fechaInicio ? config.fechaInicio : fecha}  ${config.fechaFin ? "Hasta:" + config.fechaFin : ""}
                            </th>
                            
                            <th colspan="4" class="descripcion">TIPO DE REPORTE: RESUMEN</th>
                            
                        </tr>
                        <tr class="border">
                            <th class="descripcion">TIPO DE MEMBRESIA</th>
                            <th class="descripcion">DÍA</th>
                            <th class="descripcion">FECHA</th>
                            <th class="descripcion">CLIENTE</th>
                            <th class="numero">METODO DE PAGO</th>
                            <th class="numero">MONTO</th>
                        </tr>
                    </thead>
                    <tbody>

                        ${listaDeVentasDetallada}
                    

                    </tbody>

                    <tfoot >
                        <tr class="border">
                            <td colspan="5" class="total-bruto">TOTAL:</td>
                            <td  class="numero"> ${subtotalBruto} USD </td>
                        </tr>
                    </tfoot>
                </table>
                `;
        },

        imprimirReporte(){
            console.log("imprimiendo reporte");

            this.imprimirElemento(this.reporteHtml(this.pagos, this.filtros))

        }


    }
}
</script>