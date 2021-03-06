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



/* global Vue, VueRouter, axios, google */

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
  mounted: function() {
    var uluru = {lat: -25.363, lng: 131.044};
    var map = new google.maps.Map(document.getElementById('map'), {
      zoom: 4,
      center: uluru
    });

    var contentString = '<div id="content">'+
        '<div id="siteNotice">'+
        '</div>'+
        '<h1 id="firstHeading" class="firstHeading">Uluru</h1>'+
        '<div id="bodyContent">'+
        '<p><b>Uluru</b>, also referred to as <b>Ayers Rock</b>, is a large ' +
        'sandstone rock formation in the southern part of the '+
        'Northern Territory, central Australia. It lies 335&#160;km (208&#160;mi) '+
        'south west of the nearest large town, Alice Springs; 450&#160;km '+
        '(280&#160;mi) by road. Kata Tjuta and Uluru are the two major '+
        'features of the Uluru - Kata Tjuta National Park. Uluru is '+
        'sacred to the Pitjantjatjara and Yankunytjatjara, the '+
        'Aboriginal people of the area. It has many springs, waterholes, '+
        'rock caves and ancient paintings. Uluru is listed as a World '+
        'Heritage Site.</p>'+
        '<p>Attribution: Uluru, <a href="https://en.wikipedia.org/w/index.php?title=Uluru&oldid=297882194">'+
        'https://en.wikipedia.org/w/index.php?title=Uluru</a> '+
        '(last visited June 22, 2009).</p>'+
        '</div>'+
        '</div>';

    var infowindow = new google.maps.InfoWindow({
      content: contentString
    });

    var marker = new google.maps.Marker({
      position: uluru,
      map: map,
      title: 'Uluru (Ayers Rock)'
    });
    marker.addListener('click', function() {
      infowindow.open(map, marker);
    });
  },
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
      keywordFilter: "",
      sortAttribute: "name",
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
    isValidProductName: function(inputProduct) {
      var lowerInputName = inputProduct.name.toLowerCase();
      var lowerNameFilter = this.nameFilter.toLowerCase();
      return lowerInputName.includes(lowerNameFilter);
    },
    isValidProductKeyword: function(inputProduct) {
      var lowerInputKeyword = inputProduct.description.toLowerCase();
      var lowerKeywordFilter = this.keywordFilter.toLowerCase();
      return lowerInputKeyword.includes(lowerKeywordFilter);
    },
    isValidProduct: function(inputProduct) {
      return (
        this.isValidProductName(inputProduct) &&
        this.isValidProductKeyword(inputProduct)
      );
    }
  },
  computed: {
    sortedProducts: function() {
      return this.products.sort(
        function(product1, product2) {
          var lowerAttribute1 = product1[this.sortAttribute].toLowerCase();
          var lowerAttribute2 = product2[this.sortAttribute].toLowerCase();
          return lowerAttribute1.localeCompare(lowerAttribute2);
        }.bind(this)
      );
    }
  }
};

// return product1[this.sortAttribute] - product2[this.sortAttribute]


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
