// var productTemplate = document.querySelector("#product-card");
// var productContainer = document.querySelector(".row");

// productContainer.appendChild(productTemplate.content.cloneNode(true));
// productContainer.appendChild(productTemplate.content.cloneNode(true));
// productContainer.appendChild(productTemplate.content.cloneNode(true));
// productContainer.appendChild(productTemplate.content.cloneNode(true));
// productContainer.appendChild(productTemplate.content.cloneNode(true));
// productContainer.appendChild(productTemplate.content.cloneNode(true));

// axios.get("http://localhost:3000/v1/products").then(function(response) {
//   var products = response.data;
//   console.log(products);

//   products.forEach(function(product) {
//     var productClone = productTemplate.content.cloneNode(true);
//     productClone.querySelector(".card-title").innerText = product.name;
//     productClone.querySelector(".price").innerText = product.price;
//     productClone.querySelector(".description").innerText = product.description;
//     productClone.querySelector(".card-img-top").src = product.image;
//     productContainer.appendChild(productClone);
//   });
// });



/* global Vue, VueRouter, axios */

var HomePage = {
  template: "#home-page",
  data: function() {
    return {
      message: "",
      products: [],
      currentProduct: {
        name: "Name goes here",
        price: "Pice goes here",
        description: "Description goes here"
      }
    };
  },
  created: function() {},
  methods: {},
  computed: {}
};

var SignupPage = {
  template: "#signup-page",
  data: function() {
    return {
      name: "",
      email: "",
      password: "",
      passwordConfirmation: "",
      errors: []
    };
  },
  methods: {
    submit: function() {
      var params = {
        name: this.name,
        email: this.email,
        password: this.password,
        password_confirmation: this.passwordConfirmation
      };
      axios
        .post("/v1/users", params)
        .then(function(response) {
          router.push("/login");
        })
        .catch(
          function(error) {
            this.errors = error.response.data.errors;
          }.bind(this)
        );
    }
  }
};

var LoginPage = {
  template: "#login-page",
  data: function() {
    return {
      email: "",
      password: "",
      errors: []
    };
  },
  methods: {
    submit: function() {
      var params = {
        auth: { email: this.email, password: this.password }
      };
      axios
        .post("/user_token", params)
        .then(function(response) {
          axios.defaults.headers.common["Authorization"] =
            "Bearer " + response.data.jwt;
          console.log(response.data.user);

          this.$root.userName = response.data.user.name;


          localStorage.setItem("jwt", response.data.jwt);
          router.push("/");
        }.bind(this))
        .catch(
          function(error) {
            this.errors = ["Invalid email or password."];
            this.email = "";
            this.password = "";
          }.bind(this)
        );
    }
  }
};

var LogoutPage = {
  template: "#logout-page",
  data: function() {
    return {
      message: "You've successfully logged out!"
    };
  },
  created: function() {
    axios.defaults.headers.common["Authorization"] = undefined;
    localStorage.removeItem("jwt");
    // router.push("/");
  }
};

var ProductsNewPage = {
  template: "#products-new-page",
  data: function() {
    return {
      name: "",
      price: "",
      description: "",
    };
  },
  methods: {
    submit: function() {
      var params = {
        input_name: this.name,
        input_price: this.price,
        input_description: this.description,
      };
      axios
        .post("/v1/products", params)
        .then(function(response) {
          router.push("/");
        })
        .catch(
          function(error) {
            this.errors = error.response.data.errors;
          }.bind(this)
        );
    }
  }
};

var IndexPage = {
  template: "#index-page",
  data: function() {
    return {
      message: "",
      products: [],
      nameFilter: "",
      // keywordFilter: "",
      currentProduct: {
        name: "Name goes here",
        price: "Pice goes here",
        description: "Description goes here"
      }
    };
  },
  created: function() {
    axios.get("v1/products").then(function(response) {
      this.products = response.data;
      console.log(this.products);
    }.bind(this)
    );
  },
  methods: {
    setCurrentProduct: function(inputProduct) {
      this.currentProduct = inputProduct;
    },
    isValidProduct: function(inputProduct) {
      var lowerInputName = inputProduct.name.toLowerCase();
      var lowerNameFilter = this.nameFilter.toLowerCase();
      return lowerInputName.includes(lowerNameFilter);
    },
    // isValidProductKeyword: function(inputProduct) {
    //   var lowerInputKeyword = inputProduct.keyword.toLowerCase();
    //   var lowerNameFilter = this.nameFilter.toLowerCase();
    //   return lowerInputName.includes(lowerNameFilter);
    // }
  },
  computed: {}
};


var router = new VueRouter({
  routes: [
    { path: "/", component: HomePage },
    { path: "/home", component: HomePage },
    { path: "/signup", component: SignupPage },
    { path: "/login", component: LoginPage },
    { path: "/logout", component: LogoutPage },
    { path: "/products/new", component: ProductsNewPage },
    { path: "/index", component: IndexPage},
  ],
  scrollBehavior: function(to, from, savedPosition) {
    return { x: 0, y: 0 };
  }
});

var app = new Vue({
  el: "#vue-app",
  router: router,
  data: function() {
    return {
      userName: '',
      userEmail: ''
    };
  },
  created: function() {
    var jwt = localStorage.getItem("jwt");
    if (jwt) {
      axios.defaults.headers.common["Authorization"] = jwt;
    }
  }
});
