// Shows Turbo confirmations (data-turbo-confirm) in the app's own dialog
// instead of the browser's native confirm().
export function confirmWithDialog(message, element) {
  const dialog = document.getElementById("confirm-dialog")
  if (!dialog) return Promise.resolve(window.confirm(message))

  dialog.querySelector("[data-confirm-message]").textContent = message
  dialog.querySelector("[data-confirm-accept]").textContent = element?.dataset?.confirmButton || "OK"
  dialog.returnValue = ""
  dialog.showModal()

  return new Promise((resolve) => {
    dialog.addEventListener("close", () => resolve(dialog.returnValue === "confirm"), { once: true })
  })
}
