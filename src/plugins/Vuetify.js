import Vue from 'vue'


Vue.use(Vuetify, {
    theme: {
        primary: "#206336",
        dark: true,
      },
      themes: {
        light: {
          primary: "#206336",
          secondary: "#b0bec5",
          accent: "#8c9eff",
          error: "#b71c1c",
        },
      },
})

const opts = {}

export default new Vuetify(opts)

// src/plugins/Vuetify.js
