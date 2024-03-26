export function judgeTime() {
	document.addEventListener('DOMContentLoaded', function () {
		console.log('ページを読み込みました')
		// タスク完了ボタンの情報を取得
		const completeTaskButton = document.getElementById('switch1');
		completeTaskButton.disabled = false;


		// タスク完了ボタンのクリックイベント

		completeTaskButton.addEventListener('change', function () {
			// Dateクラスからインスタンスを作成
			console.log('aa');
			completeTaskButton.disabled = true;
			const currentTime = new Date();
			// 時間や、分を取得
			const hours = currentTime.getHours();
			const minutes = currentTime.getMinutes();
			// 開始時間と終了時間を、HTMLから取得
			const startDateTime = document.querySelector('.start-time').textContent;
			const endDateTime = document.querySelector('.end-time').textContent;

			// 初期値を投入
			// const startDateTime = '2024-11-08 13:40'
			// const endDateTime = '2024-11-08 14:40'
			const [startDate, startTime] = startDateTime.split(' ');
			const [startHours, startMinutes] = startTime.split(':').map(Number);
			const [endDate, endTime] = endDateTime.split(' ');
			const [endHours, endMinutes] = endTime.split(':').map(Number);
			const startTotalMinutes = startHours * 60 + startMinutes;
			const endTotalMinutes = endHours * 60 + endMinutes;
			const currentTotalMinutes = hours * 60 + minutes;
			// NaN NaN 889
			console.log(startTotalMinutes, endTotalMinutes, currentTotalMinutes);



					// //JSONオブジェクトから任意のプロパティを取り出す
					// // start_timeは、'2024-11-08 13:40'
					// const startDateTime = mydata['start_time'];
					// const endDateTime = mydata['end_time'];

			/*6:50-7:10(6:55にクリア) 時間が違う場合に対応するため、時間を分数に直して比較。
			*/
			if (startTotalMinutes <= currentTotalMinutes && currentTotalMinutes <= endTotalMinutes) {
				// 成功メッセージ
				console.log('成功')
				showModal('タスクは成功しました！');
			} else {
				// 失敗メッセージ
				console.log('失敗')
				showModal('タスクは失敗しました！');
			}
				})
		});

				// モーダル関連の情報を取得
		const modal = document.getElementById('modal');
		const modalText = document.getElementById('modalText');

		// モーダルの閉じるボタンの情報を取得
		const closeButton = document.querySelector('.closeButton');
		// モーダルを表示する関数
		function showModal(message) {
			modalText.textContent = message;
			modal.style.display = 'block';
		}

		// 閉じるボタンのイベント
		closeButton.addEventListener('click', function () {
			// モーダル非表示
			modal.style.display = 'none';
		})
		// モーダル外をクリックしていた場合閉じる
		window.addEventListener('click', function (event) {
			if (event.target == modal) {
				modal.style.display = 'none'
			}
		})

}
// export function test () {
// 	// 開始時間と終了時間を取得
// 	fetch('/tasks')
// 		// レスポンスのJSONを解析
// 		.then(resonse => response.json())
// 		.then(mydata => {
// 			//JSONオブジェクトから任意のプロパティを取り出す
// 			console.log(mydata);
// 		})
judgeTime();
