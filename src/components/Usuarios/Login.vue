<template>
  <div class="fondo">
    <v-container fluid fill-height>
      <v-layout align-center justify-center>
    
        <v-flex xs12 sm8 md4>
            <!-- <div style="background-color: #206336; border-radius: 100%; height: 120px; width: 150px;  ">
              <v-card-text class="py-4 text-center">
                <img src="@/assets/logo.png" width="100" alt="">
              </v-card-text>

            </div> -->

          <v-card class="elevation-12" height="100%" >
            <v-toolbar dark color="#206336">
              <v-toolbar-title>Iniciar sesión</v-toolbar-title>
            </v-toolbar>
            <v-card-text>
              <v-form>
                <v-text-field
                  id="usuario"
                  prepend-icon="person"
                  name="usuario"
                  label="Usuario"
                  type="text"
                  v-model="usuario"
                ></v-text-field>
                <v-text-field
                  id="password"
                  prepend-icon="lock"
                  name="password"
                  label="Contraseña"
                  type="password"
                  v-model="password"
                ></v-text-field>
              </v-form>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="#206336" width="100%" style="color: aliceblue;" @click="iniciarSesion">Ingresar</v-btn>
            </v-card-actions>

         

            <v-card-text class="py-2 text-center">
              {{ new Date().getFullYear() }} — Desarrollado por <a href="https://cyberstaffstore.com/" target="_blank">Cyber Staff C.A | Click para soporte</a> 
            </v-card-text>
          </v-card>
        </v-flex>
      
      </v-layout>
        
      <v-snackbar
          v-model="mostrarMensaje"
          :timeout="3000"
          :color="mensaje.color"
          top
          >
          {{ mensaje.texto }}
      </v-snackbar>
    </v-container>

 
 
  </div>
</template>
<script>
import HttpService from '../../Servicios/HttpService'

export default {
  name: "Login",
  data: () => ({
    usuario: "",
    password: "",
    mensaje: {
      texto: "",
      color: "",
    },
    mostrarMensaje: false
  }),

  methods: {
    iniciarSesion() {
      if (!this.usuario) {
          this.mostrarMensaje = true
          this.mensaje.texto = "Debes colocar el usuario"
          this.mensaje.color = "warning"
          return
      }
      if (!this.password) {
          this.mostrarMensaje = true
          this.mensaje.texto = "Debes colocar la contraseña"
          this.mensaje.color = "warning"
          return
      }
      let payload = {
          metodo: "login",
          usuario: {
              usuario: this.usuario,
              password: this.password
          }
      }
      HttpService.obtenerConDatos(payload, "usuarios.php")
      .then(resultado => {
          if(resultado) {
              this.$emit("logeado", resultado)
          }
      })

      
    },
  },
};
</script>
<style >
.fondo{
  background-color: #206336;
  background-image: url("../../assets/fondo_4.svg");
  background-attachment: fixed;
  background-size: cover;
  height: 100%;
}
</style>