document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('.toggle-row').forEach(function(row) {
    row.addEventListener('click', function() {
      const raceId = row.getAttribute('data-race-id');
      const studentList = document.getElementById(`student-list-${raceId}`);
      const button = row.querySelector('button');
      const icon = button.querySelector('i');

      if (studentList.style.display === 'none' || studentList.style.display === '') {
        studentList.style.display = 'block';
        icon.classList.remove('bi-chevron-right');
        icon.classList.add('bi-chevron-down');
      } else {
        studentList.style.display = 'none';
        icon.classList.remove('bi-chevron-down');
        icon.classList.add('bi-chevron-right');
      }
    });
  });
});