<template>
  <div>
    <v-app-bar color="primary" class="flex-grow-0" app dark>
      <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>
        <!-- <img src="@/assets/logo.png" width="50"> -->
        Sistema Gimnasio
      </v-toolbar-title>
      <v-spacer></v-spacer>

      <v-btn icon @click="salir">
        <v-icon>logout</v-icon>
      </v-btn>
    </v-app-bar>
    <v-navigation-drawer app v-model="drawer" class="fondo">
      <v-list-item>
        <v-list-item-content>
          <v-list-item-title class="text-h6 white--text"> 
            <v-avatar>
              <img
                :src="urlImagen(logo)"
                alt="Logo"
              >
            </v-avatar>
            {{ nombreGimnasio }}
            </v-list-item-title>
          <v-list-item-subtitle class="text-h6 white--text"> {{ nombreUsuario.toUpperCase() }} </v-list-item-subtitle>
          <v-list-item-subtitle class="text-h6 white--text"> {{ rolUsuario.toLowerCase() }} </v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>
      <v-divider></v-divider>
      <v-list dense nav>
        <v-list-item
          v-for="item in items"
          :key="item.title"
          link
          :to="item.link"
          class="white--text"
        >
          <v-list-item-icon >
            <v-icon class="white--text">{{ item.icon }}</v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
  </div>
</template>
<script>
import Utiles from '../Servicios/Utiles';
let listaDeNavegacionR = [],
listaDeNavegacionA = [];

listaDeNavegacionR = [
      // { title: "Inicio", icon: "mdi-view-dashboard", link: "/" },
      { title: "Recepción", icon: "mdi mdi-table-edit", link: "/recepcion" },
      // { title: "Registrar visita", icon: "mdi-home-account", link: "/registrar-visita" },
      { title: "Miembros", icon: "mdi-weight-lifter", link: "/miembros" },
      { title: "Generar Reporte de pagos", icon: "mdi-account-cash", link: "/pagos" },
      { title: "Mi perfil", icon: "mdi-account-key", link: "/perfil" },
    ];

listaDeNavegacionA = [
      { title: "Inicio", icon: "mdi-view-dashboard", link: "/" },
      { title: "Recepción", icon: "mdi mdi-table-edit", link: "/recepcion" },
      // { title: "Registrar visita", icon: "mdi-home-account", link: "/registrar-visita" },
      { title: "Usuarios", icon: "mdi-account-box", link: "/usuarios" },
      { title: "Miembros", icon: "mdi-weight-lifter", link: "/miembros" },
      {
        title: "Membresías",
        icon: "mdi-wallet-membership",
        link: "/membresias",
      },
      { title: "Pagos", icon: "mdi-account-cash", link: "/pagos" },
      { title: "Visitas", icon: "mdi-calendar-star", link: "/visitas" },
      { title: "Configurar", icon: "mdi-cog", link: "/configurar" },
      { title: "Mi perfil", icon: "mdi-account-key", link: "/perfil" },
    ];


export default {
  name: "Encabezado",
  data: () => ({
    drawer: false,
    nombreUsuario: "",
    rolUsuario: "",
    nombreGimnasio: "",
    logo: "",
    items: [],
  }),

  mounted(){
    this.nombreUsuario = localStorage.getItem("nombreUsuario");
    this.rolUsuario = localStorage.getItem("rolUsuario");
    this.nombreGimnasio = localStorage.getItem("nombreGimnasio");
    this.logo = localStorage.getItem("logoGimnasio");
    this.items = this.rolUsuario == "RECEPCIONISTA" ? listaDeNavegacionR : listaDeNavegacionA;

    // this.validarPermisosDelRol(this.items);
    
  },

  methods:{ 
    // validarPermisosDelRol(items){
    //   let estatusDelPermiso = false;
    //    items.forEach(permiso => {
    //         console.log(window.location.pathname);
    //         if(permiso.link.slice(1) == window.location.pathname) return estatusDelPermiso = true;
    //    });

    //    if(!estatusDelPermiso) window.location.href='/#/recepcion';
    // },
    salir(){
      localStorage.removeItem('logeado')
      localStorage.removeItem('nombreUsuario')
      localStorage.removeItem('idUsuario')
      localStorage.removeItem('rolUsuario')
      window.location.reload()
    },

    urlImagen(imagen) {
      return Utiles.generarURL(imagen);
    },

  },
};

</script>
<style>
.fondo {
  background-color: #003333;
  background-attachment: fixed;
  background-size: cover;
}
</style>
