export function init(ctx, payload) {
  ctx.importCSS("output.css");
  ctx.importJS("output.js");

  ctx.root.innerHTML = `
    <div class="app">
      <h1>Hello World</h1>
      <form>
        <div class="container">
          <div>
            <p>API Hostname: <input type="text" name="hostname" value="https://api.machines.dev" placeholder="Enter api hostname" /></p>
          </div>
          <div>
          <p>Token: <input type="text" name="token" placeholder="Enter your token here" /></p>
        </div>
          // <div>
          //   <p>Username: <input type="text" name="username" placeholder="Enter username here" /></p>
          // </div>
          <div>
            <p>Application: <input type="text" name="application" placeholder="Enter application name here" /></p>
          </div>
          <div>
            <p>Image: <input type="text" name="image" placeholder="Enter image name to deploy here" /></p>
          <div>
            <button id="refreshBtn" type="submit">Refresh</button>
            <button id="deployBtn" type="submit">Deploy</button>
          </div>
        </div>
      </form>
      // Testing refresh
      <p class="test"></p>
    </div>
  `;

//   <ul x-data="{ colors: ['Red', 'Orange', 'Yellow'] }">
//     <template x-for="color in colors">
//         <li x-text="color"></li>
//     </template>
// </ul>

  const hostnameEl = document.getElementById("hostname")
  const tokenEl = document.getElementById("token")
  const usernameEl = document.getElementById("username") 
  const applicationEl = document.getElementById("application")
  const imageEl = document.getElementById("image")
  
  const refreshBtn = document.getElementById("refreshBtn");
  const deployBtn = document.getElementById("deployBtn");

  const testEl = document.querySelector("test");

  // Get the list of machines for this application
  refreshBtn.addEventListener("click", (event) => {
    ctx.pushEvent("refresh", [tokenEl.value, applicationEl.value]);
  // Deploy the given image to the application
  deployBtn.addEventListener("click", (event) => {
    ctx.pushEvent("deploy");
  });

  ctx.handleEvent("refresh", (ids) => {
    testEl.value = ids;
  });

  // Used for event listeners if used
  ctx.handleSync(() => {
    // Synchronously invokes change listeners
    document.activeElement &&
      document.activeElement.dispatchEvent(new Event("change"));
  });
})}
