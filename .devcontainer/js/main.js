function showSidebar() {
	const sidebar = document.querySelector('.sidebar')
	sidebar.style.display = 'flex'
}

function hideSidebar() {
	const sidebar = document.querySelector('.sidebar')
	sidebar.style.display = 'none'
}

function showTime() {
	const now = new Date()
	const hours = now.getHours()
	const minutes = ('0' + now.getMinutes()).slice(-2)
	const time = hours + ':' + minutes

	document.getElementById('time').innerText = time

	const mm = ('0' + (now.getMonth() + 1)).slice(-2)
	const dd = ('0' + now.getDate()).slice(-2)
	const day = '日月火水木金土'[now.getDay()]
	const date = mm + '/' + dd + '(' + day + ')'

	document.getElementById('date').innerText = date
}

// 1秒ごとにshowTime関数を実行して時刻を更新
setInterval(showTime, 1000)

// 初回表示時にも時刻を表示
showTime()
