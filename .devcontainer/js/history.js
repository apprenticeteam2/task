function getToday() {
	const date = new Date()

	const yyyy = date.getFullYear()
	const mm = ('0' + (date.getMonth() + 1)).slice(-2)
	const dd = ('0' + date.getDate()).slice(-2)

  return yyyy + '-' + mm + '-' + dd
}

document.getElementById('date-picker').value = getToday()
