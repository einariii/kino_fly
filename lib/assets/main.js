export function init(ctx, payload) {
  ctx.importCSS("output.css");
  ctx.importCSS("input.css");
  ctx.importJS("output.js");

  // Deploy field should depend on image (SOME ARE MISSING I WANT TO CHANGE ANYWAY)
  const regions = [
    "ams",
    "arn",
    "atl",
    "cdg",
    "den",
    "dfw",
    "ewr",
    "eze",
    "fra",
    "gdl",
    "gig",
    "gru",
    "hkg",
    "iad",
    "jnb",
    "lax",
    "lhr",
    "maa",
    "mad",
    "mia",
    "nrt",
    "ord",
    "otp",
    "qro",
    "scl",
  ];

  ctx.root.innerHTML = `
    <div class="app">
      <h1>Hello World</h1>
      <form>
        <div class="container">
          <div>
            <p>API Hostname: <input id="hostname" type="text" name="hostname" value="https://api.machines.dev" placeholder="Enter API hostname" /></p>
          </div>
          <div>
            <p>Token: <input id="token" type="text" name="token" placeholder="Enter your token here" /></p>
          </div>
          <div>
            <p>Application: <input id="application" type="text" name="application" placeholder="Enter application name here" /></p>
          </div>
          <div>
            <p>Image: <input id="image" type="text" name="image" placeholder="Enter image name to deploy here" /></p>
          <div>
            <button class="btn" id="refreshBtn" type="submit">Refresh</button>
            <button class="deploybutton" id="deployBtn" type="submit">Deploy</button>
          </div>
        </div>
      </form>
      <div>
        <output id="test123"></output>
      </div>
    </div>
  `;

  //   <ul x-data="{ colors: ['Red', 'Orange', 'Yellow'] }">
  //     <template x-for="color in colors">
  //         <li x-text="color"></li>
  //     </template>
  // </ul>

  const hostnameEl = document.getElementById("hostname");
  hostnameEl.value = payload.fields.hostname;

  const tokenEl = document.getElementById("token");
  tokenEl.value = payload.fields.token;

  const applicationEl = document.getElementById("application");
  applicationEl.value = payload.fields.application;

  const imageEl = document.getElementById("image");
  imageEl.value = payload.fields.image;

  const refreshBtn = document.getElementById("refreshBtn");
  const deployBtn = document.getElementById("deployBtn");

  const testEl = document.getElementById("test123");

  // Get the list of machines for this application
  refreshBtn.addEventListener("click", (event) => {
    payload = [tokenEl.value, applicationEl.value];
    console.log(payload);
    ctx.pushEvent("refresh", payload);
  });

  // Deploy the given image to the application
  deployBtn.addEventListener("click", (event) => {
    ctx.pushEvent("deploy");
  });

  ctx.handleEvent("refresh", (value) => {
    console.log("REFRESH" + value);
    testEl.value = value;
  });

  // Used for event listeners if used
  ctx.handleSync(() => {
    // Synchronously invokes change listeners
    document.activeElement &&
      document.activeElement.dispatchEvent(new Event("change"));
  });
}
