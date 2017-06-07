$(document).on('turbolinks:load', function() {

// Waits for load before removing disabled from button to prevent early click.
$('#validate-card').removeAttr('disabled');
  cardForm = document.getElementById('card-form');
  if (cardForm) {

    var expiry = document.getElementById('expiry'),
        cvc    = document.getElementById('cvv'),
        submit = document.getElementById('validate-card'),
        result = document.getElementById('result'),
        fullName = document.getElementById('full-name'),
        addressOne = document.getElementById('address-one'),
        addressTwo = document.getElementById('address-two'),
        city = document.getElementById('city'),
        state = document.getElementById('state'),
        zip = document.getElementById('zip'),
        country = document.getElementById('country'),
        newCardFields = document.getElementById('new-card-fields'),
        cardValue = document.getElementById('on_file')
        defaultCard = document.getElementById('default-card');

        // checks for defaultCard passed to view.
        if (defaultCard.value) {
          defaultCard.setAttribute("checked", "checked");
        } else {
          defaultCard.setAttribute("checked", ""); // For IE
          defaultCard.removeAttribute("checked"); // For other browsers
          defaultCard.checked = false;
        }

        if (expiry) {
          payform.expiryInput(expiry);
          payform.cvcInput(cvc);

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
      $( "#card-form" ).submit(function( event ) {

        $form = $('#card-form');

        var valid     = [],
            expiryObj = payform.parseCardExpiry(expiry.value);

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

        if (validation === false) {
          // if errors are present do not process
          $('#validate-card').html('Please Correct Errors').prop('disabled', true).css('cursor', 'not-allowed');

        } else if (validation === true) {
          // if array has no errors process
          // add the exp-month and exp-year to the form in the proper format.
          $form.append($('<input type="hidden" name="card_name" />').val(fullName.value));
          $form.append($('<input type="hidden" name="card_exp_month" />').val(expiryObj.month));
          $form.append($('<input type="hidden" name="card_exp_year" />').val(expiryObj.year));
          $form.append($('<input type="hidden" name="card_name" />').val(fullName.value));
          $form.append($('<input type="hidden" name="address_line_one" />').val(addressOne.value));
          $form.append($('<input type="hidden" name="address_line_two" />').val(addressTwo.value));
          $form.append($('<input type="hidden" name="address_city" />').val(city.value));
          $form.append($('<input type="hidden" name="address_state" />').val(state.value));
          $form.append($('<input type="hidden" name="address_zip" />').val(zip.value));
          $form.append($('<input type="hidden" name="address_country" />').val(country.value));
          $form.append($('<input type="hidden" name="default_card" />').val(defaultCard.checked));

          // disable submit to prevent duplicate charges
          $form.find('#validate-card').html('Processing...<i class="fa fa-spinner fa-pulse"></i>').prop('disabled', true).css('cursor', 'not-allowed');
          // submit form, stripe doesn't need to re-verify card on params update
          $form.get(0).submit();
        }
      return false;
    });
  });

    // Card input functions for verification and error handling.
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

    function validateDefaultChecked(value) {
      if (value.checked)
        return true;
      else
        return false;
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
        $('#validate-card').html('Submit Card Info').prop('disabled', false).css('cursor', 'default');

      } else {
        addClass(input.parentNode, 'state-error');
        removeClass(input.parentNode, 'state-success');
        var errorPresent = document.getElementsByClassName('state-error');
        var inputError = errorPresent.length >= 0;

        if ( inputError = true ) {
          $('#validate-card').html('Please Correct Errors').prop('disabled', true).css('cursor', 'not-allowed');
        } else {
          $('#validate-card').html('Submit Card Info').prop('disabled', false).css('cursor', 'default');
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
  }
});
