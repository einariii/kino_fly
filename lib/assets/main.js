export function init(ctx, payload) {
  ctx.importCSS("output.css");
  ctx.importJS("output.js");

  // Really bad first layout, doesn't work rn
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
          <div>
            <p>Username: <input type="text" name="username" placeholder="Enter username here" /></p>
          </div>
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
      <ul>
        <li>Machines go here</li>
      </ul>
    </div>
  `;

  const refreshBtn = document.getElementById("refreshBtn");

  const deployBtn = document.getElementById("deployBtn");

  refreshBtn.addEventListener("click", (event) => {
    ctx.pushEvent("refresh", {});
  });

  deployMsgBtn.addEventListener("click", (event) => {
    ctx.pushEvent("deploy", {});
  });

  // Used for event listeners if used
  ctx.handleSync(() => {
    // Synchronously invokes change listeners
    document.activeElement &&
      document.activeElement.dispatchEvent(new Event("change"));
  });
}
