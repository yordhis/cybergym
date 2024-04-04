<template>
  <div>
    <v-card>
      <v-card-title>
        <span class="text-h5">Renovar membresia para {{miembro.nombre}}</span>
      </v-card-title>
      <v-card-text>

          <v-container>

            <template>
              <v-card
                :color="miembro.estado == 'VENCIDO' ? 'red' : 'green' "
                class="mx-auto px-2 mb-2"
                max-width="100%"
              >
                <v-card-item>
                  <div>
                    <div class="text-h6 mb-1 p-2">
                      Datos de membresia
                    </div>
                    
                    <div class="text-caption p-2">
                      <b>Membresia:</b> {{ miembro.membresia ? miembro.membresia : "No tiene membresia" }} <br>
                      <b>Fecha de vencimiento de membresia:</b> {{ miembro.fechaFin ? miembro.fechaFin : "No tiene fecha de vencimiento"}} <br>
                      <b>Cantidad de días vencidos:</b> {{ diasDeDiferencia }}<br>
                    </div>
                  </div>
                </v-card-item>
              </v-card>
            </template>


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

            
           


            <template v-if="alert_model.text != '' ">
              <v-alert 
                :color="alert_model.color"
                :icon="alert_model.icono"
                :title="alert_model.title"
                closable
              >{{ alert_model.text }}</v-alert>

            </template>
            
            <template>
              <v-container fluid>
                <v-checkbox
                  v-model="estatusUsoFechaNueva"
                  :disabled="true"
                  label="Se ha activado el modificador de fecha de membresia seleccione una fecha"
                ></v-checkbox>
              </v-container>

              <v-row justify="center">
                <v-date-picker
                  show-adjacent-months
                  :disabled="this.diasDeDiferencia >= 7 ? false : true"
                  v-model="fechaNuevaDeMembresiaSeleccionada"
                  title="Su fecha de membresia es:"
                  color="primary"
                  :first-day-of-week="1"
                  :min="miembro.fechaFin"
                 
                  locale="es-se"
                ></v-date-picker>
              
              </v-row>

            </template>

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
  props: ["matricula", "fechaFin"],

  data:()=>({
    membresiaSeleccionada: { id: "", nombre: "", precio: "", duracion: "" },
    fechaDePago: new Date(Date.now()).toISOString().split('T')[0],
    fechaNuevaDeMembresiaSeleccionada: "",
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
    diasDeDiferencia: 0,
    miembro:{},
  
  }),

  mounted(){
    this.obtenerMembresias();
    this.getMiembroMatricula(this.matricula);


  },

  methods:{

 

    getMiembroMatricula(matricula) {
      const payload = { metodo: "getMiembroMatricula", busqueda: matricula };
      HttpService.obtenerConDatos(payload, "miembros.php")
      .then((resultado) => {
        this.miembro = resultado.length ? resultado[0] : {};
        console.log(this.miembro);
        console.log(this.miembro.fechaFin);
        let fecha1 = new Date(this.miembro.fechaFin.split(" ")[0]);
        let fecha2 = new Date(new Date(Date.now()).toISOString().split('T')[0]);
        let diferencia = fecha2.getTime() - fecha1.getTime();
        
        this.diasDeDiferencia = diferencia / 1000 / 60 / 60 / 24;
        this.estatusUsoFechaNueva = this.diasDeDiferencia >= 7 ? true : false;
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
      if( this.fechaNuevaDeMembresiaSeleccionada == "" && this.estatusUsoFechaNueva == true ){
        this.alert_model.text="Debe seleccionar una fecha para la membresia";
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
     let fechaDeInicioDeLamembresia = "";
      if(this.estatusUsoFechaNueva){
        fechaDeInicioDeLamembresia = this.fechaNuevaDeMembresiaSeleccionada
      }else{
        console.log(this.miembro.fechaFin);
        if(this.miembro.fechaFin){
          fechaDeInicioDeLamembresia = this.miembro.fechaFin;
        }else{
          fechaDeInicioDeLamembresia = this.fechaDePago;
        }
      }

      let payload = {
        metodo: 'pagar',
        pago: {
          matricula: this.matricula,
          pago: this.membresiaSeleccionada.precio,
          idMembresia: this.membresiaSeleccionada.id,
          duracion: this.membresiaSeleccionada.duracion,
          fecha: this.fechaDePago, // fecha de pago
          fechaInicio: fechaDeInicioDeLamembresia,
          idUsuario: localStorage.getItem('idUsuario'),
          metodosDePago: metodosDePagoFinal
        }
      }
      
      HttpService.registrar(payload,"miembros.php")
      .then(registrado => {
        if(registrado){
          this.cargando = false
          this.$emit("pagado", registrado)
          console.log(registrado)
          window.location.reload()
        }
      })

      console.log(payload)
    }

  }
};
</script>