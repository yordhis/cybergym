<template>
  <div>
    <v-card>
      <v-card-title>
        <span class="text-h5">Realizar pago para {{matricula}}</span>
      </v-card-title>
      <v-card-text>
          <v-container>
            <v-select
              v-model="membresiaSeleccionada"
              :hint="`${membresiaSeleccionada.nombre}, ${membresiaSeleccionada.precio}`"
              :items="membresias"
              item-text="nombre"
              item-value="id"
              label="Selecciona una membresía"
              persistent-hint
              return-object
              single-line
            >
            </v-select>

            <template>
              <v-container fluid>
                <v-checkbox
                  v-model="estatusUsoFechaNueva"
                  :label="`Usar fecha de pago para la membresia: ${estatusUsoFechaNueva.toString()}`"
                ></v-checkbox>
              </v-container>
            </template>

            <template v-if="alert_model.text != '' ">
              <v-alert 
                :color="alert_model.color"
                :icon="alert_model.icono"
                :title="alert_model.title"
                closable
              >{{ alert_model.text }}</v-alert>

            </template>


            <v-row justify="center">
              <v-date-picker
                v-model="fechaSeleccionada"
                :first-day-of-week="1"
                locale="es-se"
              >
              </v-date-picker>
            </v-row>

            <v-row>
              <v-col cols5>
                <v-select
                  v-model="valueM1"
                  :items="items"
                  chips
                  label="Método de pago"
                  @change="agregarMonto1"
                ></v-select>
              </v-col>

              <v-col cols5>
                <v-text-field clearable label="Monto"
                v-model="montoM1" 
                
                ></v-text-field>
              </v-col>
              <v-col cols2>

                <v-btn  
                variant="tonal" 
                color="success"
                @click="agregarMetodo"
                >
                  +
                </v-btn>
              </v-col>
            </v-row>

            <template v-if="masMetodo">
              <v-row>
                <v-col cols5>
                  <v-select
                    v-model="valueM2"
                    :items="items"
                    chips
                    label="Método de pago"
                    @change="agregarMonto2"
                  ></v-select>
                </v-col>
  
                <v-col cols5>
                  <v-text-field 
                  clearable 
                  label="Monto" 
                  v-model="montoM2"
                  ></v-text-field>
                </v-col>

                <v-col cols2>
                  <v-btn
                      class="ma-2"
                      color="red"
                      @click="eliminarMetodo"
                    >
                      Decline
                      <v-icon
                        end
                        icon="mdi-cancel"
                      ></v-icon>
                  </v-btn>
                </v-col>

              </v-row>
            </template>
          

          </v-container>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="blue darken-1" text @click="cerrarDialogo">
          Cerrar
        </v-btn>
        <v-btn
          color="blue darken-1"
          text
          @click="realizarPago"
        >
          Registrar
        </v-btn>
      </v-card-actions>
    </v-card>
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
export default {
  name: "RealizarPago",
  props: ["matricula"],

  data:()=>({
    membresiaSeleccionada: { id: "", nombre: "", precio: "", duracion: "" },
    fechaSeleccionada: "",
    estatusUsoFechaNueva: false,
    membresias: [],
    cargando: false,
    alert_model:{ color: "", text: "", title: "", icono:""},
    items: ['TD | PUNTO', 'EFECTIVO', 'DIVISAS', 'TRANSFERENCIA', 'PAGO MOVIL', 'TC | PUNTO', 'ZELLE', 'USDT'],
    valueM1: "",
    valueM2: "",
    masMetodo:false,
    montoM1:0,
    montoM2:0,
    miembro:{}
  
  }),

  mounted(){
    this.obtenerMembresias();
    this.miembro = this.getMiembroMatricula(this.matricula)
    console.log(this.miembro);
  },

  methods:{


    getMiembroMatricula(matricula) {
      const payload = { metodo: "getMiembroMatricula", busqueda: matricula };
      HttpService.obtenerConDatos(payload, "miembros.php").then((resultado) => {
        console.log(resultado.length)
        console.log(resultado)
        this.miembro = resultado.length ? resultado[0] : {};
      });
    },


    agregarMonto1(){
      this.montoM1 = this.membresiaSeleccionada.precio;
    },
    agregarMonto2(){
      this.montoM2 = this.membresiaSeleccionada.precio - this.montoM1;
    },
    eliminarMetodo(){
      this.masMetodo = false;
    },
    agregarMetodo(){
      this.masMetodo = true;
    },
    obtenerMembresias() {
      const payload = { metodo: "get" };
      HttpService.obtenerConDatos(payload, "membresias.php").then(
        (respuesta) => {
          this.membresias = respuesta;
        }
      );
    },

    cerrarDialogo(){
      this.$emit("cerrar", false)
    },

    realizarPago(){
      /** Validamos la membresia */
      if(this.membresiaSeleccionada.id == ""){
        this.alert_model.text="Seleccione membresia";
        this.alert_model.color="error";
        this.alert_model.icono="$error";
        this.alert_model.title="Requerido"
        return setTimeout(()=>{this.alert_model.text=""},1500);
      }

      /** validamos la fecha */
      if(this.fechaSeleccionada == ""){
        this.alert_model.text="Debe seleccionar una fecha";
        this.alert_model.color="error";
        this.alert_model.icono="$error";
        this.alert_model.title="Requerido"
        return setTimeout(()=>{this.alert_model.text=""},1500);
      }
      // this.cargando = true

      /** creamos el array de objeto de los metodos de pago */
      let metodosDePagoFinal=[],
      noHayMetodo=0;

      
      if(this.montoM1 > 0 ) metodosDePagoFinal+=`${this.valueM1}:${this.montoM1}`;
      else noHayMetodo++;
      if(this.montoM2 > 0 ) metodosDePagoFinal+=` | ${this.valueM2}:${this.montoM2}`;



      /** validamos los metodos*/
      if(noHayMetodo){
        this.alert_model.text="Agrege un método de pago";
        this.alert_model.color="error";
        this.alert_model.icono="$error";
        this.alert_model.title="Requerido"
        return setTimeout(()=>{this.alert_model.text=""},1500);
      }

     console.log(this.miembro);
      let payload = {
        metodo: 'pagar',
        pago: {
          matricula: this.matricula,
          pago: this.membresiaSeleccionada.precio,
          idMembresia: this.membresiaSeleccionada.id,
          duracion: this.membresiaSeleccionada.duracion,
          fecha: this.fechaSeleccionada,
          fechaInicio: this.estatusUsoFechaNueva ? this.fechaSeleccionada : this.miembro.fechaFin 
                                                                          ? this.miembro.fechaFin
                                                                          : this.fechaSeleccionada,
          idUsuario: localStorage.getItem('idUsuario'),
          metodosDePago: metodosDePagoFinal
        }
      }

      console.log(payload);
      
      HttpService.registrar(payload,"miembros.php")
      .then(registrado => {
        if(registrado){
          this.cargando = false
          this.$emit("pagado", registrado)
          console.log(registrado)
        }
      })

      console.log(payload)
    }

  }
};
</script>