$(document).on('turbolinks:load', function() {

// Waits for load before removing disabled from button to prevent early click.
$('#validate-card').removeAttr('disabled');
var cardForm = document.getElementById('new-card');
if (cardForm) {

  var ccnum  = document.getElementById('card'),
      expiry = document.getElementById('expiry'),
      cvc    = document.getElementById('cvv'),
      submit = document.getElementById('validate'),
      result = document.getElementById('result'),
      fullName = document.getElementById('full-name'),
      addressOne = document.getElementById('address-one'),
      addressTwo = document.getElementById('address-two'),
      city = document.getElementById('city'),
      state = document.getElementById('state'),
      zip = document.getElementById('zip'),
      country = document.getElementById('country'),
      newCardFields = document.getElementById('new-card-fields'),
      cardValue = document.getElementById('on_file');
      defaultCard = document.getElementById('default-card');

      if (ccnum) {
        payform.cardNumberInput(ccnum);
        payform.expiryInput(expiry);
        payform.cvcInput(cvc);

        ccnum.addEventListener('input', updateType);
        cvc.addEventListener('input', validateCVC);
        expiry.addEventListener('input', validateExpiry);
        fullName.addEventListener('input', validateFullName);
        addressOne.addEventListener('input', validateFieldKeypress);
        city.addEventListener('input', validateFieldKeypress);
        state.addEventListener('input', validateFieldKeypress);
        zip.addEventListener('input', validateFieldKeypress);
        country.addEventListener('input', validateFieldKeypress);
      }


  jQuery(function() {
      $( "#new-card" ).submit(function( event ) {

        $form = $('#new-card');

        var valid     = [],
            expiryObj = payform.parseCardExpiry(expiry.value);

        // validate inputs
        valid.push(fieldStatus(ccnum,  payform.validateCardNumber(ccnum.value)));
        valid.push(fieldStatus(expiry, payform.validateCardExpiry(expiryObj)));
        valid.push(fieldStatus(cvc,    payform.validateCardCVC(cvc.value)));
        valid.push(validateSubmitName(fullName));
        valid.push(validateField(addressOne));
        valid.push(validateField(city));
        valid.push(validateField(state));
        valid.push(validateField(zip));
        valid.push(validateField(country));

        // builds he validation array and changes to single true or false
        validation = valid.every(Boolean) ? true : false;

        if (newCardFields.classList.contains('hidden')) {
          // if old card is selected form is submitted
          $form.find('#validate-card').html('Processing... <i class="fa fa-spinner fa-pulse"></i>').prop('disabled', true).css('cursor', 'not-allowed');
          event.preventDefault();
          $form.get(0).submit();

        } else {
          // if new card is chosen card fields are validated
          if (validation === false) {
            // if errors are present do not process
            $('#validate-card').html('Please Correct Errors').prop('disabled', true).css('cursor', 'not-allowed');
            // probably don't need to double check above === false with === true below but it's there anyways
          } else if (validation === true) {
            // if array has no errors process
            // add the exp-month and exp-year to the form in the proper format.
            $form.append($('<input type="hidden" data-stripe="exp-month" />').val(expiryObj.month));
            $form.append($('<input type="hidden" data-stripe="exp-year" />').val(expiryObj.year));

            // disable submit to prevent duplicate charges
            $form.find('#validate-card').html('Processing...<i class="fa fa-spinner fa-pulse"></i>').prop('disabled', true).css('cursor', 'not-allowed');

            // Send form to Stripe for validation/processing
            Stripe.card.createToken($form, stripeResponseHandler);
          }
        }
      return false;
    });
  });

  // Response handling.
  var stripeResponseHandler;
  stripeResponseHandler = function(status, response) {
    var $form, token;
    Stripe.setPublishableKey($("meta[name='stripe-key']").attr("content"));

    $form = $('#new-card');

    if (response.error) {
      // Leaving the line below but it isn't quite necessary
      // Error handling below is a backup for now.
      $form.find('.payment-errors').text(response.error.message);

      return $('#validate-card').html('Add Card').prop('disabled', false).css('cursor', 'default');
    } else {
      token = response.id;
      $form.append($('<input type="hidden" name="stripeToken" />').val(token));
      $form.append($('<input type="hidden" name="card_name" />').val(response.card.name));
      $form.append($('<input type="hidden" name="card_last_four" />').val(response.card.last4));
      $form.append($('<input type="hidden" name="card_exp_month" />').val(response.card.exp_month));
      $form.append($('<input type="hidden" name="card_exp_year" />').val(response.card.exp_year));
      $form.append($('<input type="hidden" name="card_type" />').val(response.card.brand));
      $form.append($('<input type="hidden" name="stripe_id" />').val(response.card.id));
      $form.append($('<input type="hidden" name="address_line_one" />').val(response.card.address_line1));
      $form.append($('<input type="hidden" name="address_line_two" />').val(response.card.address_line2));
      $form.append($('<input type="hidden" name="address_city" />').val(response.card.address_city));
      $form.append($('<input type="hidden" name="address_state" />').val(response.card.address_state));
      $form.append($('<input type="hidden" name="address_zip" />').val(response.card.address_zip));
      $form.append($('<input type="hidden" name="address_country" />').val(response.card.country));
      $form.append($('<input type="hidden" name="default_card" />').val(defaultCard.checked));

      return $form.get(0).submit();
    }
    return false;

  };

  // Validation functions for inputs
  function updateType(e) {
    var fontClass = 'fa fa-cc-';
    var cardType = payform.parseCardType(e.target.value);

    if (cardType == null) {
      var fontClass = 'card';
      $('#append-type').removeClass();
    } else {
      var fontClass = 'fa fa-cc-';
      $('#append-type').removeClass();
      $('#append-type').addClass('icon-append');
      $('#append-type').addClass(fontClass + cardType);
    }

    // Check validity of card each time a keypress happens
    var validCard = fieldStatus(ccnum,  payform.validateCardNumber(ccnum.value));
    if (validCard == true) {
      return true
    } else {
      return false
    }
  }

  function validateCVC(e) {
    fieldStatus(cvc,    payform.validateCardCVC(cvc.value));
  }

  function validateExpiry(e) {
    expiryObj = payform.parseCardExpiry(expiry.value);
    fieldStatus(expiry, payform.validateCardExpiry(expiryObj));
  }

  function validateFullName(e) {
    var name = e.target

    var onlyText = /^[\D a-zA-Z]([-']?[a-zA-Z]+?.)*( [a-zA-Z]([-']?[a-zA-Z ]+)*)+$/;

    if (onlyText.test(name.value)) {
      fieldStatus(name, true)
      return true
    } else {
      fieldStatus(name, false)
      return false
    }
  }

  function validateSubmitName(name) {
    var fullName = name,
        onlyText = /^[\D a-zA-Z]([-']?[a-zA-Z]+?.)*( [a-zA-Z]([-']?[a-zA-Z ]+)*)+$/;

    if (onlyText.test(fullName.value)) {
      fieldStatus(name, true)
      return true
    } else {
      fieldStatus(name, false)
      return false
    }
  }

  function validateField(value) {
    var field = value;

    if (field.value) {
      fieldStatus(field, true)
      return true;
    } else {
      fieldStatus(field, false)
      return false;
    }
  }

  function validateFieldKeypress(value) {
    var field = value.target;

    if (field.value) {
      fieldStatus(field, true)
      return true;
    } else {
      fieldStatus(field, false)
      return false;
    }
  }

  function toggleCard(e) {
    cardFields = document.getElementsByClassName("card-fields");
    cardOne = document.getElementById('on_file');
    cardTwo = document.getElementsByName('on_file');
    var fieldsLength = cardFields.length;

    for (var i = 0; i < fieldsLength; i++) {
      if (cardFields[i].classList.contains('hidden')) {
        removeClass(cardFields[i], 'hidden')
        cardOne.name = ' ';
      } else {
        addClass(cardFields[i], 'hidden')
        $('#validate-card').html('Add Card').prop('disabled', false).css('cursor', 'default');
        cardOne.name = 'on_file';
      }
    }
  }

  function validateCountryKeypress(country) {
    var countryValue = country.target;

    if (countryValue.value) {
      fieldStatus(countryValue, true)
      return true;
    } else {
      fieldStatus(countryValue, false)
      return false;
    }
  }

  function fieldStatus(input, valid) {
    if (valid) {
      removeClass(input.parentNode, 'state-error');
      addClass(input.parentNode, 'state-success');
      $('#validate-card').html('Add Card').prop('disabled', false).css('cursor', 'default');

    } else {
      addClass(input.parentNode, 'state-error');
      removeClass(input.parentNode, 'state-success');
      var errorPresent = document.getElementsByClassName('state-error');
      var inputError = errorPresent.length >= 0;

      if ( inputError = true ) {
        $('#validate-card').html('Please Correct Errors').prop('disabled', true).css('cursor', 'not-allowed');
      } else {
        $('#validate-card').html('Add Card').prop('disabled', false).css('cursor', 'default');
      }
    }
    return valid;
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
} // added for error handling
});

// Toggle old and new card function.
  var newCard = document.getElementById('new-card-toggle'),
      oldCard = document.getElementById('old-card');

  $(document).on('click', '#new-card-toggle, #old-card', function toggleCard(e) {
    cardFields = document.getElementsByClassName("card-fields");
    cardOne = document.getElementById('on_file');
    cardTwo = document.getElementsByName('on_file');

    var fieldsLength = cardFields.length;

    for (var i = 0; i < fieldsLength; i++) {
      if (cardFields[i].classList.contains('hidden')) {
        removeClass(cardFields[i], 'hidden')
        cardOne.name = ' ';
      } else {
        addClass(cardFields[i], 'hidden')
        $('#validate-card').html('Add Card').prop('disabled', false).css('cursor', 'default');
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
