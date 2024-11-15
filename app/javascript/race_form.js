document.addEventListener('DOMContentLoaded', function() {
  const form = document.getElementById('race-form');
  const laneModal = new bootstrap.Modal(document.getElementById('laneModal'));
  const confirmLanesButton = document.getElementById('confirm-lanes');
  const studentSelect = document.querySelector('select[name="race[student_ids][]"]');
  const studentLaneForm = document.getElementById('student-lane-form');
  const laneFieldsContainer = document.getElementById('lane-fields');
  const laneError = document.getElementById('lane-error');

  function createLaneSelectHTML(studentId, studentName, laneNumbers) {
    const select = document.createElement('select');
    select.classList.add('form-control', 'lane-select');
    select.id = `lane-${studentId}`;
    select.dataset.studentId = studentId;
    select.required = true;

    const placeholderOption = document.createElement('option');
    placeholderOption.value = "";
    placeholderOption.disabled = true;
    placeholderOption.selected = true;
    placeholderOption.textContent = 'Select a lane number';
    select.appendChild(placeholderOption);

    laneNumbers.forEach(lane => {
      const option = document.createElement('option');
      option.value = lane;
      option.textContent = lane;
      select.appendChild(option);
    });

    return select;
  }

  function populateStudentLaneForm() {
    studentLaneForm.innerHTML = '';
    const selectedOptions = Array.from(studentSelect.selectedOptions);

    if (selectedOptions.length < 2) {
      alert('Please select at least two students.');
      return false;
    }

    const laneNumbers = Array.from({ length: selectedOptions.length }, (_, i) => i + 1);
    const fragment = document.createDocumentFragment();

    selectedOptions.forEach(option => {
      const studentId = option.value;
      const studentName = option.text;

      const laneDiv = document.createElement('div');
      laneDiv.classList.add('form-group', 'mt-2');

      const label = document.createElement('label');
      label.setAttribute('for', `lane-${studentId}`);
      label.textContent = studentName;

      laneDiv.appendChild(label);
      laneDiv.appendChild(createLaneSelectHTML(studentId, studentName, laneNumbers));
      fragment.appendChild(laneDiv);
    });

    studentLaneForm.appendChild(fragment);
    return true;
  }

  form.addEventListener('submit', function(event) {
    event.preventDefault();
    if (populateStudentLaneForm()) laneModal.show();
  });

  function confirmLanes() {
    laneFieldsContainer.innerHTML = '';
    const lanes = new Set();
    const selects = studentLaneForm.querySelectorAll('.lane-select');
    let duplicateFound = false;
    const fragment = document.createDocumentFragment();

    selects.forEach(select => {
      const laneNumber = select.value;
      const studentId = select.dataset.studentId;

      if (laneNumber && lanes.has(laneNumber)) {
        duplicateFound = true;
      } else {
        lanes.add(laneNumber);

        const laneField = document.createElement('input');
        laneField.type = 'hidden';
        laneField.name = 'race[student_races_attributes][][lane]';
        laneField.value = laneNumber;

        const studentIdField = document.createElement('input');
        studentIdField.type = 'hidden';
        studentIdField.name = 'race[student_races_attributes][][student_id]';
        studentIdField.value = studentId;

        fragment.appendChild(laneField);
        fragment.appendChild(studentIdField);
      }
    });

    if (duplicateFound) {
      laneError.style.display = 'block';
    } else {
      laneError.style.display = 'none';
      laneFieldsContainer.appendChild(fragment);
      laneModal.hide();
      form.submit();
    }
  }

  confirmLanesButton.addEventListener('click', confirmLanes);
});