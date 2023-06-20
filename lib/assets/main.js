import * as Vue from "https://cdn.jsdelivr.net/npm/vue@3.2.26/dist/vue.esm-browser.prod.js";

export function init(ctx, payload) {
  ctx.importCSS("output.css");

  const regions = {
    ams: "Amsterdam",
    arn: "Stockholm",
    atl: "Atlanta",
    bog: "Bogotá",
    bos: "Boston",
    cdg: "Paris",
    den: "Denver",
    dfw: "Dallas",
    ewr: "Secaucus",
    eze: "Ezeiza",
    fra: "Frankfurt",
    gdl: "Guadalajara",
    gig: "Rio de Janeiro",
    gru: "Sao Paulo",
    hkg: "Hong Kong",
    iad: "Ashburn",
    jnb: "Johannesburg",
    lax: "Los Angeles",
    lhr: "London",
    maa: "Chennai",
    mad: "Madrid",
    mia: "Miami",
    nrt: "Tokyo",
    ord: "Chicago",
    otp: "Bucharest",
    qro: "Querétaro",
    scl: "Santiago",
    sea: "Seattle",
    sin: "Singapore",
    sjc: "San Jose",
    syd: "Sydney",
    waw: "Warsaw",
    yul: "Montreal",
    yyz: "Toronto",
  };

  const MachineElement = {
    props: {
      id: {
        type: String,
        default: "",
      },
      app: {
        type: String,
        default: "",
      },
      name: {
        type: String,
        default: "",
      },
      image: {
        type: String,
        default: "",
      },
      region: {
        type: String,
        default: "",
      },
      state: {
        type: String,
        default: "",
      },
    },
    methods: {
      onClickStartOrStop() {
        payload = { machine: this.id, app: this.app };
        if (this.state === "started") {
          ctx.pushEvent("stop", payload);
        } else if (this.state === "stopped") {
          ctx.pushEvent("start", payload);
        }
      },
      onClickDelete() {
        ctx.pushEvent("delete", { machine: this.id, app: this.app });
      },
    },
    computed: {
      startOrStop() {
        if (this.state === "started") {
          return "Stop";
        } else if (this.state === "stopped") {
          return "Start";
        } else {
          return "";
        }
      },
      regionName() {
        console.log("REGION", this.region);
        return regions[this.region];
      },
      stateCap() {
        const capitalized =
          this.state.charAt(0).toUpperCase() + this.state.slice(1);
        return capitalized;
      },
    },
    template: `
    <div class="container flex flex-col">
      <div class="flex flex-row gap-x-4 items-center">
        <p class="w-44">{{ name }}</p>
        <p class="w-44 overflow-auto">{{  image }}</p>
        <p class="w-24">{{ regionName }}</p>
        <p class="w-24">{{ stateCap }}</p>
        <button type="button" @click="onClickStartOrStop" class="w-16 bg-purple-400 text-white rounded hover:bg-purple-500 active:bg-purple-600 transition-colors duration-200 ease-in-out">{{ startOrStop }}</button>
        <button type="button" @click="onClickDelete" class="w-16 bg-gray-500 text-white rounded hover:bg-gray-700 active:bg-gray-800 transition-colors duration-200 ease-in-out">Delete</button>
      </div>
    </div>
    `,
  };

  const app = Vue.createApp({
    components: { MachineElement },
    data() {
      return {
        hostname: payload.fields.hostname,
        token: payload.fields.token,
        // Make this blank after
        app: payload.fields.app,
        // app: "",
        image: "",
        region: "",
        machines: Vue.ref([]),
        regions: regions,
        auto_refresh: payload.fields.auto_refresh,
      };
    },
    methods: {
      refresh() {
        ctx.pushEvent("refresh");
      },
      deploy() {
        // Include deploy payload
        console.log("PUSHING REGION INPUT", this.region);
        // const region_code = reverseLookup(regions, this.region);
        const region_code = this.region;
        console.log("PUSHING REGION", region_code);
        ctx.pushEvent("deploy", { code: region_code });
        this.image = "";
        this.region = "";
      },
      updateBackend() {
        ctx.pushEvent("update", {
          hostname: this.hostname,
          token: this.token,
          app: this.app,
          image: this.image,
          region: this.region,
        });
      },
      toggleAutoRefresh() {
        this.auto_refresh = !this.auto_refresh;
        ctx.pushEvent("toggle_auto_refresh", {
          auto_refresh: this.auto_refresh,
        });
      },
    },
    computed: {},
    template: `
    <div class="app">
      <h1 class="text-xl font-bold">Fly Machines</h1>
      <h2 class="text-md font-bold">Inputs</h2>
      <form>
        <div class="container">
          <div>
            <p>API Hostname: <input id="hostname" type="text" name="hostname" placeholder="Enter API hostname" v-model="hostname" @input="updateBackend" /></p>
          </div>
          <div>
            <p>Token: <input id="token" type="password" name="token" placeholder="Enter your token here" v-model="token" @input="updateBackend" /></p>
          </div>
          <div>
            <p>Application: <input id="app" type="text" name="app" placeholder="Enter application name here" v-model="app" @input="updateBackend"/></p>
          </div>
          <div>
            <p>Image: <input id="image" type="text" name="image" placeholder="Enter image name to deploy here" v-model="image" @input="updateBackend"/></p>
          </div>
          <div>
            <p>Region: <select v-model="region" @change="updateBackend">
              <option v-for="(region_pretty, region) in regions" :key="region" :value="region">{{ region_pretty }}</option>
            </select></p>
          </div>
          <div class="flex justify-start gap-x-2">
          <button type="submit" @click="refresh" class="bg-gray-500 text-white rounded hover:bg-gray-700 active:bg-gray-800 transition-colors duration-200 ease-in-out">Refresh</button>
          <button type="submit" @click="deploy" class="bg-gray-500 text-white rounded hover:bg-gray-700 active:bg-gray-800 transition-colors duration-200 ease-in-out">Deploy</button>
        </div>
        </div>
      </form>
      <div>
        <p><button type="button" @click="toggleAutoRefresh" class="bg-gray-500 text-white rounded hover:bg-gray-700 active:bg-gray-800 transition-colors duration-200 ease-in-out">Toggle Auto Refresh</button> {{ auto_refresh ? 'On' : 'Off' }}</p>
      </div>
      <h2 class="text-md font-bold">Machines</h2>
      <div id="machines" v-if="machines && machines.length > 0">
        <machine-element
          v-for="machine in machines"
          :app="app"
          :id="machine.id"
          :name="machine.name"
          :image="machine.image"
          :region="machine.region"
          :state="machine.state"
        />
      </div>
      <div v-else>
        <p>No machines found</p>
      </div>
    </div>
    `,
  }).mount(ctx.root);

  ctx.handleEvent("refresh", (payload) => {
    console.log("REFRESH PAYLOAD RECIEVED", payload);
    if (!machinesUnchanged(app.machines, payload.machines)) {
      const sorted_machines = sortMachines(payload.machines);
      console.log("SORTED MACHINES", sorted_machines);
      const out = sorted_machines;
      // const out = payload.machines;
      app.machines = out;
    }
  });
}

// Sometimes machines returns same objects in diff order and we don't want to update UI in that case
function machinesUnchanged(list1, list2) {
  if (list1.length !== list2.length) {
    return false;
  }

  const sortedList1 = list1.slice().sort(compareObjects);
  const sortedList2 = list2.slice().sort(compareObjects);

  for (let i = 0; i < sortedList1.length; i++) {
    const obj1 = sortedList1[i];
    const obj2 = sortedList2[i];

    // Check if the objects have the same keys
    const keys1 = Object.keys(obj1);
    const keys2 = Object.keys(obj2);
    if (keys1.length !== keys2.length) {
      return false;
    }

    for (const key of keys1) {
      // Check if the keys are the same
      if (!keys2.includes(key)) {
        return false;
      }

      // Check if the values are the same
      if (obj1[key] !== obj2[key]) {
        return false;
      }
    }
  }

  return true;
}

function compareObjects(obj1, obj2) {
  let comparison = obj1.image.localeCompare(obj2.image);
  if (comparison !== 0) return comparison;

  comparison = obj1.state.localeCompare(obj2.state);
  if (comparison !== 0) return comparison;

  comparison = obj1.region.localeCompare(obj2.region);
  if (comparison !== 0) return comparison;

  return obj1.state.localeCompare(obj2.state);
}

function sortMachines(list) {
  return list.slice().sort(compareObjects);
}
