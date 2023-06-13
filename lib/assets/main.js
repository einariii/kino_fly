export function init(ctx, payload) {
  ctx.importCss("output.css");
  ctx.importJS("output.js");

  ctx.root.innerHTML = `
    <div class="app">
      <h1>Hello World</h1>
      <form>
        // Almost always will be "https://api.machines.dev"
        <input type="text" name="hostname" placeholder="Enter api hostname" />
        // Output from "fly auth token"
        <input type="text" name="username" placeholder="Enter auth token" />
        // All machines must be associated with an application
        <input type="text" name="application" placeholder="Enter application name" />
        // The name of the docker image to deploy to the machine
        <input type="text" name="image" placeholder="Enter image name to deploy" />
        <button type="submit">Deploy</button>
      </form>
      // List all the running machines on the selected application
      // These should have a stop button for running machines and a start button for stopped machines
    </div>
  `;

  // // Used for event listeners if used
  // ctx.handleSync(() => {
  //   // Synchronously invokes change listeners
  //   document.activeElement &&
  //     document.activeElement.dispatchEvent(new Event("change"));
  // });
}
