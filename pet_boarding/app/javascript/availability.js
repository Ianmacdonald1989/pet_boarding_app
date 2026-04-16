function buildRow(row) {
  const badgeClass =
    row.size === "small"
      ? "badge badge--small"
      : row.size === "medium"
        ? "badge badge--medium"
        : row.size === "large"
          ? "badge badge--large"
          : "badge";

  return `
    <tr>
      <td><span class="${badgeClass}">${row.size}</span></td>
      <td>${row.total}</td>
      <td>${row.booked}</td>
      <td><strong>${row.available}</strong></td>
    </tr>
  `;
}

async function fetchAvailability(startDate, endDate) {
  const params = new URLSearchParams({ start_date: startDate, end_date: endDate });
  const res = await fetch(`/availability?${params.toString()}`, {
    headers: { Accept: "application/json" },
    credentials: "same-origin",
  });
  return await res.json();
}

function attachAvailabilityWidget() {
  const root = document.querySelector("[data-availability-root]");
  if (!root) return;

  const startInput = root.querySelector("[data-availability-start]");
  const endInput = root.querySelector("[data-availability-end]");
  const statusEl = root.querySelector("[data-availability-status]");
  const tbody = root.querySelector("[data-availability-body]");

  if (!startInput || !endInput || !statusEl || !tbody) return;

  let inFlight = 0;

  async function refresh() {
    const startDate = startInput.value;
    const endDate = endInput.value;

    tbody.innerHTML = "";

    if (!startDate || !endDate) {
      statusEl.textContent = "Choose start and end dates to see cage availability.";
      return;
    }

    const requestId = ++inFlight;
    statusEl.textContent = "Checking availability…";

    try {
      const data = await fetchAvailability(startDate, endDate);
      if (requestId !== inFlight) return;

      if (!data.ok) {
        statusEl.textContent = data.error || "Could not load availability.";
        return;
      }

      statusEl.textContent = `Availability for ${data.start_date} → ${data.end_date}`;
      tbody.innerHTML = data.rows.map(buildRow).join("");
    } catch (_e) {
      if (requestId !== inFlight) return;
      statusEl.textContent = "Could not load availability.";
    }
  }

  startInput.addEventListener("change", refresh);
  endInput.addEventListener("change", refresh);
  startInput.addEventListener("blur", refresh);
  endInput.addEventListener("blur", refresh);

  refresh();
}

document.addEventListener("turbolinks:load", attachAvailabilityWidget);
document.addEventListener("DOMContentLoaded", attachAvailabilityWidget);

