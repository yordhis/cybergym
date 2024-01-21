<template>
  <div>
    <h1>Recepción</h1>
    <v-card>
      <v-card-text>
        <v-text-field 
        v-model="cedula"
        :loading="cargando"
        @keyup.enter="getMiembro(cedula)"
        label="INGRESE NÚMERO DE CÉDULA O ESCANEÉ EL QR">
        </v-text-field>
      </v-card-text>
    </v-card>

    <template v-if="typeof miembroSeleccionado.id != 'undefined'">
      <v-row justify="center" class="mt-5">
        <v-col cols="auto">
          <v-card class="mx-auto" max-width="500" title="Datos Prosonales">
            <v-card-title>
              <img
                :src="urlImagen(miembroSeleccionado.imagen)"
                width="75"
                class="img"
              />
              {{ miembroSeleccionado.nombre }}
            </v-card-title>
            <v-card-title>
              Cédula: {{ miembroSeleccionado.cedula }} <br />
              Teléfono: {{ miembroSeleccionado.telefono }} <br />
              Dirección: {{ miembroSeleccionado.direccion }} <br />
            </v-card-title>
          </v-card>
        </v-col>
        <v-col cols="auto">
          <v-card class="mx-auto" max-width="500" title="Datos Membresia">
            <v-card-title>
              {{
                miembroSeleccionado.membresia
                  ? miembroSeleccionado.membresia
                  : "No poseé membresia"
              }}
            </v-card-title>
            <v-card-title>
              Fecha de incio: {{ miembroSeleccionado.fechaInicio }} <br />
              Fecha de vencimiento: {{ miembroSeleccionado.fechaFin }} <br />

              <v-btn
                inline
                :color="estado(miembroSeleccionado.estado)"
                style="width: 200px; font-size: 16px;"
                class="mx-2"
                rounded="xl"
                size="x-large"
                v-on:click="realizarPago(miembroSeleccionado.matricula)"
              >
                {{ miembroSeleccionado.estado ? miembroSeleccionado.estado : "Agregar membresia"}}
              </v-btn>

              <v-btn
                inline
                color="info"
                rounded="sm"
                size="s-small"
                v-on:click="registrarVisitaRegular(miembroSeleccionado)"
              >
                Registrar Visita
              </v-btn>
            </v-card-title>
          </v-card>
        </v-col>
        <v-col cols="auto">
          <v-btn
            inline
            color="warning"
            rounded="xl"
            size="x-large"
            v-on:click="limpiarRecepcion()"
          >
            Limpiar
          </v-btn>
        </v-col>
      </v-row>
    </template>

    <template v-else>
      <v-row justify="center" class="mt-5">
        <v-col cols="auto">
          <v-card class="mx-auto" max-width="500" title="Datos Prosonales">
            <v-card-title>
              No hay resultados
            </v-card-title>
          </v-card>
        </v-col>
      </v-row>
    </template>

    <v-dialog v-model="mostrarRealizarPago" persistent max-width="600">
      <realizar-pago
        :matricula="matriculaSeleccionada"
        @cerrar="cerrarDialogoPago"
        @pagado="onPagado"
      />
    </v-dialog>

    <v-snackbar
      v-model="mostrarMensaje"
      :timeout="3000"
      :color="mensaje.color"
      top
    >
      {{ mensaje.texto }}
    </v-snackbar>

    <cartas-personalizadas :cartas="datosVisitas" />
  </div>
</template>
<script>
import HttpService from "../../Servicios/HttpService";
import Utiles from "../../Servicios/Utiles";
import RealizarPago from "../Miembros/RealizarPago.vue";
import CartasPersonalizadas from "../Dialogos/CartasPersonalizadas.vue";
let f = new Date();
export default {
  name: "BusquedaMiembro",
  components: { RealizarPago, CartasPersonalizadas },
  data: () => ({
    fechaActual: `${f.getFullYear()}-${f.getMonth() + 1}-${f.getDate()}`,
    cargando: false,
    busqueda: "",
    cedula: "",
    miembros: [],
    miembroSeleccionado: {},
    matriculaSeleccionada: "",
    mostrarMensaje: false,
    mensaje: {
      color: "",
      texto: ""
    },
    mostrarRealizarPago: false,
    etiquetasVisitasHora: [],
    valoresVisitasHora: [],
    etiquetasVisitasSemana: [],
    valoresVisitasSemana: [],
    etiquetasVisitasMes: [],
    valoresVisitasMes: []
  }),
  mounted() {
    this.obtenerDatos();
  },

  methods: {
    obtenerDatos() {
      this.cargando = true;
      HttpService.obtenerConDatos(
        {
          metodo: "obtener"
        },
        "inicio.php"
      ).then(resultado => {
        this.crearCartas(resultado.datosVisitas, resultado.datosPagos);
        this.etiquetasVisitasHora = Utiles.obtenerClaves(resultado.visitasHora);
        this.valoresVisitasHora = Utiles.obtenerValores(resultado.visitasHora);
        let visitasSemana = Utiles.cambiarDiaSemana(resultado.visitasSemana);
        this.etiquetasVisitasSemana = Utiles.obtenerClaves(visitasSemana);
        this.valoresVisitasSemana = Utiles.obtenerValores(visitasSemana);
        this.etiquetasVisitasMes = Utiles.obtenerClaves(resultado.visitasMes);
        this.valoresVisitasMes = Utiles.obtenerValores(resultado.visitasMes);

        this.cargando = false;
      });
    },

    crearCartas(visitas, pagos) {
      this.datosVisitas = [
        // {
        // color: "purple darken-1",
        // icono: "mdi-calendar-star",
        // nombre: "Total visitas",
        // total: visitas.totalVisitas,
        // },
        {
          color: "pink darken-1",
          icono: "mdi-calendar",
          nombre: "Visitas hoy",
          total: visitas.visitasHoy
        },
        // {
        //   color: "red darken-1",
        //   icono: "mdi-calendar-range",
        //   nombre: "Visitas semana",
        //   total: visitas.visitasSemana
        // }
      ];
    },

    registrarVisitaRegular(data) {
      console.log(data);
      this.cargando = true;
      HttpService.registrar(
        {
          metodo: "registrar_regular",
          visita: {
            idUsuario: localStorage.getItem("idUsuario"),
            miembro: data
          }
        },
        "visitas.php"
      ).then(resultado => {
        if (resultado) {
          this.cargando = false;
          // this.mostrarDialogoRegular = false
          this.mostrarMensaje = true;
          this.mensaje = {
            texto: "Visita regular registrar",
            color: "success"
          };
        }
      });
    },

    limpiarRecepcion() {
      this.cargando = false;
      this.busqueda = "";
      this.miembros = [];
      this.miembroSeleccionado = {};
      this.matriculaSeleccionada = "";
      this.mostrarMensaje = false;
      (this.mensaje = {
        color: "",
        texto: ""
      }),
        (this.mostrarRealizarPago = false);
    },

    urlImagen(imagen) {
      return Utiles.generarURL(imagen);
    },

    cerrarDialogoPago(resultado) {
      this.mostrarRealizarPago = resultado;
    },

    realizarPago(matricula) {
      this.matriculaSeleccionada = matricula;
      this.mostrarRealizarPago = true;
    },

    async onPagado(resultado) {
      if (resultado) {
        this.mostrarRealizarPago = false;
        this.mostrarMensaje = true;
        if(this.fechaActual > this.miembroSeleccionado.fechaFin) this.miembroSeleccionado.estado = 'VENCIDO';

        this.getMiembro(this.miembroSeleccionado.cedula);
        console.log(this.miembroSeleccionado);
        
        this.miembroSeleccionado.estado = 'ACTIVO';
        
        this.mensaje = {
          color: "success",
          texto: "Pago realizado con éxito"
        };
      }
    },

    estado(val) {
      return val === "ACTIVO"
        ? "success"
        : val === "VENCIDO"
        ? "error"
        : "warning";
    },

    getMiembro(cedula) {
      this.cargando = true;
      const payload = { metodo: "getMiembro", busqueda: cedula };
      HttpService.obtenerConDatos(payload, "miembros.php").then((resultado) => {
        console.log(resultado.length)
        this.cargando = false;
        this.miembroSeleccionado = resultado.length ? resultado[0] : {};
        this.cedula = "";
      });
    },

    buscarMiembros(value) {
      if (value.data) {
        this.busqueda += value.data;
        let payload = {
          metodo: "obtener_nombre_matricula_cedula",
          busqueda: this.busqueda
        };
        this.cargando = true;
        HttpService.obtenerConDatos(payload, "miembros.php").then(
          resultados => {
            this.miembros = resultados;
            this.cargando = false;
          }
        );
      }
   
      this.busqueda = "";
      this.miembros = [];
    },

    customFilter(item, queryText, itemText) {
      const textOne = item.nombre.toLowerCase();
      const textTwo = item.matricula.toString();
      const textTree = item.cedula.toString();
      const searchText = queryText.toLowerCase();

      return (
        textOne.indexOf(searchText) > -1 ||
        textTwo.indexOf(searchText) > -1 ||
        textTree.indexOf(searchText) > -1
      );
    }
  },

  watch: {
    miembroSeleccionado(miembro) {
        // console.log(this.fechaActual);
        // if(this.fechaActual > miembro.fechaFin) this.miembroSeleccionado.estado = 'VENCIDO';
        this.$emit("seleccionado", miembro);
    }
  }
};
</script>
