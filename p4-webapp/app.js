const $ = (id) => document.getElementById(id);
const fmt = (iso) => new Date(iso).toLocaleDateString(undefined, { month: "short", day: "numeric", year: "numeric" });
const esc = (s) => String(s).replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
const opts = (list, sel) => list.map((o) => `<option${o === sel ? " selected" : ""}>${o}</option>`).join("");

let requests = [];
let editingId = null;
let toastTimer;

function toast(msg, isError) {
  const t = $("toast");
  t.textContent = msg;
  t.className = "show" + (isError ? " error" : "");
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => (t.className = ""), 2500);
}

async function load() {
  try {
    requests = await getRequests();
    render();
  } catch (e) {
    console.error(e);
    toast("Could not load requests. Reload the page to try again.", true);
  }
}

function render() {
  const counts = OPTIONS.statuses.map((s) => `<div class="stat"><b>${requests.filter((r) => r.status === s).length}</b><span>${s}</span></div>`);
  $("stats").innerHTML = `<div class="stat"><b>${requests.length}</b><span>Total requests</span></div>` + counts.join("");

  const q = $("search").value.trim().toLowerCase();
  const rows = requests.filter((r) =>
    (!q || (r.title + " " + r.description).toLowerCase().includes(q)) &&
    (!$("fStatus").value || r.status === $("fStatus").value) &&
    (!$("fCategory").value || r.category === $("fCategory").value) &&
    (!$("fPriority").value || r.priority === $("fPriority").value));

  $("rows").innerHTML = rows.map((r) => `<tr>
    <td>${r.id}</td>
    <td class="title"><button class="link" data-view="${r.id}">${esc(r.title)}</button></td>
    <td>${r.category}</td>
    <td><span class="badge ${r.priority}">${r.priority}</span></td>
    <td><span class="status-badge">${esc(r.status)}</span></td>
    <td>${fmt(r.updatedAt)}</td>
    <td><button class="btn sm" data-edit="${r.id}">Edit</button> <button class="btn sm danger" data-delete="${r.id}">Delete</button></td>
  </tr>`).join("");

  $("empty").hidden = rows.length > 0;
  $("empty").textContent = requests.length === 0
    ? "No requests yet. Select Create request to add one."
    : "No requests match your search or filters. Clear them to see all requests.";
}

function openForm(r) {
  editingId = r ? r.id : null;
  $("formTitle").textContent = r ? "Edit " + r.id : "Create request";
  const f = $("form");
  f.title.value = r ? r.title : "";
  f.description.value = r ? r.description : "";
  f.category.value = r ? r.category : OPTIONS.categories[0];
  f.priority.value = r ? r.priority : "Medium";
  f.status.value = r ? r.status : "Open";
  $("formDialog").showModal();
}

async function showDetail(id) {
  try {
    const r = await getRequest(id);
    $("detail").innerHTML = `<h2>${esc(r.title)}</h2>
      <dl><dt>Request ID</dt><dd>${r.id}</dd><dt>Description</dt><dd>${esc(r.description)}</dd>
      <dt>Category</dt><dd>${r.category}</dd><dt>Priority</dt><dd>${r.priority}</dd><dt>Status</dt><dd>${r.status}</dd>
      <dt>Created</dt><dd>${fmt(r.createdAt)}</dd><dt>Last updated</dt><dd>${fmt(r.updatedAt)}</dd></dl>
      <div class="actions"><button class="btn" id="closeDetail">Close</button></div>`;
    $("closeDetail").onclick = () => $("detailDialog").close();
    $("detailDialog").showModal();
  } catch (e) { toast(e.message, true); }
}

async function run(action, okMsg) {
  try { await action(); toast(okMsg); await load(); }
  catch (e) { toast("Something went wrong: " + e.message, true); }
}

function init() {
  $("fStatus").insertAdjacentHTML("beforeend", opts(OPTIONS.statuses));
  $("fCategory").insertAdjacentHTML("beforeend", opts(OPTIONS.categories));
  $("fPriority").insertAdjacentHTML("beforeend", opts(OPTIONS.priorities));
  const f = $("form");
  f.category.innerHTML = opts(OPTIONS.categories);
  f.priority.innerHTML = opts(OPTIONS.priorities);
  f.status.innerHTML = opts(OPTIONS.statuses);

  ["search", "fStatus", "fCategory", "fPriority"].forEach((id) => $(id).addEventListener("input", render));
  $("createBtn").onclick = () => openForm(null);
  document.querySelector("[data-close]").onclick = () => $("formDialog").close();

  f.addEventListener("submit", () => {
    const data = { title: f.title.value.trim(), description: f.description.value.trim(), category: f.category.value, priority: f.priority.value, status: f.status.value };
    editingId
      ? run(() => updateRequest(editingId, data), "Request updated.")
      : run(() => createRequest(data), "Request created.");
  });

  $("rows").addEventListener("click", (e) => {
    const b = e.target.closest("button"); if (!b) return;
    if (b.dataset.view) showDetail(b.dataset.view);
    if (b.dataset.edit) openForm(requests.find((r) => r.id === b.dataset.edit));
    if (b.dataset.delete && confirm("Delete " + b.dataset.delete + "? This cannot be undone."))
      run(() => deleteRequest(b.dataset.delete), "Request deleted.");
  });

  load();
}
init();
