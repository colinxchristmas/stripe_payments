// Toggle old and new card button on forms.
  var newCard = document.getElementById('new-card-toggle'),
      oldCard = document.getElementById('old-card');

  $(document).on('click', '#new-card-toggle, #old-card', function toggleCard(e) {
    cardFields = document.getElementsByClassName("card-fields");
    cardOne = document.getElementById('on_file');
    cardTwo = document.getElementsByName('on_file');
    console.log('cardFields: ', cardFields);

    var fieldsLength = cardFields.length;

    for (var i = 0; i < fieldsLength; i++) {
      if (cardFields[i].classList.contains('hidden')) {
        removeClass(cardFields[i], 'hidden')
        cardOne.name = ' ';
      } else {
        addClass(cardFields[i], 'hidden')
        $('#validate-card').html('Add Card').prop('disabled', false).css('cursor', 'default');
        $('#validate').html('Purchase').prop('disabled', false).css('cursor', 'default');
        cardOne.name = 'on_file';
      }
    }

    function addClass(ele, _class) {
      if (ele.className.indexOf(_class) === -1) {
        ele.className += ' ' + _class;
      }
    }

    function removeClass(ele, _class) {
      if (ele.className.indexOf(_class) !== -1) {
        ele.className = ele.className.replace(_class, '');
      }
    }
  });
