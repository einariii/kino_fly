export function init(ctx, payload) {
  ctx.importCSS("output.css");
  ctx.importJS("https://unpkg.com/alpinejs@3.10.5/dist/cdn.min.js");

  ctx.root.innerHTML = `
  <div x-data="{ count: 0 }">
    <button x-on:click="count = count > 0 ? count-1 : count">-</button>
    <span x-text="count"></span>
    <button x-on:click="count++">+</button>
  </div>
  `;

  // ctx.root.innerHTML = `
  //   <div class="app">
  //     <h1>Hello World</h1>
  //     <form>
  //       <div class="container">
  //         <div>
  //           <p>API Hostname: <input id="hostname" type="text" name="hostname" value="https://api.machines.dev" placeholder="Enter API hostname" /></p>
  //         </div>
  //         <div>
  //           <p>Token: <input id="token" type="text" name="token" placeholder="Enter your token here" /></p>
  //         </div>
  //         <div>
  //           <p>Application: <input id="app" type="text" name="app" placeholder="Enter application name here" /></p>
  //         </div>
  //         <div>
  //           <p>Image: <input id="image" type="text" name="image" placeholder="Enter image name to deploy here" /></p>
  //         <div>
  //           <button class="btn" id="refreshBtn" type="submit">Refresh</button>
  //           <button class="btn" id="createBtn" type="submit">Deploy</button>
  //         </div>
  //       </div>
  //     </form>
  //     <div>
  //       <pre><output id="test123"></output></pre>
  //     </div>
  //   </div>
  // `;

  // const hostnameEl = document.getElementById("hostname");
  // hostnameEl.value = payload.fields.hostname;

  // const tokenEl = document.getElementById("token");
  // tokenEl.value = payload.fields.token;

  // const appEl = document.getElementById("app");
  // appEl.value = payload.fields.app;

  // const imageEl = document.getElementById("image");
  // imageEl.value = payload.fields.image;

  // const refreshBtn = document.getElementById("refreshBtn");
  // const createBtn = document.getElementById("createBtn");

  // const testEl = document.getElementById("test123");
  // testEl.value = payload.fields.machines;

  // // Get the list of machines for this application
  // refreshBtn.addEventListener("click", (event) => {
  //   payload = [tokenEl.value, appEl.value];
  //   console.log(payload);
  //   ctx.pushEvent("refresh", payload);
  // });

  // create the given image to the application
  // createBtn.addEventListener("click", (event) => {
  //   ctx.pushEvent("deploy", {
  //     token: tokenEl.value,
  //     app: appEl.value,
  //     image: imageEl.value,
  //   });
  // });

  // ctx.handleEvent("refresh", (value) => {
  //   console.log("REFRESH");
  //   console.log(value);
  //   const formattedVal = JSON.stringify(value, null, 4);
  //   testEl.value = formattedVal;
  // });

  // Used for event listeners if used
  // ctx.handleSync(() => {
  // Synchronously invokes change listeners
  //   document.activeElement &&
  //     document.activeElement.dispatchEvent(new Event("change"));
  // });
}
