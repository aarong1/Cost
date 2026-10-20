$(document).ready(function() {

  // Tab Navigation Functionality
  $('.nav-item').on('click', function() {
    // Remove active class from all nav items
    $('.nav-item').removeClass('active');
    // Add active class to clicked item
    $(this).addClass('active');

    // Hide all tab content
    $('.tab-pane').removeClass('active show')

    // Show corresponding tab content based on nav item text
    var navText = $(this).text().trim().toLowerCase();
    var tabId = '';

    switch(navText) {
      case 'dashboard':
        tabId = 'dashboard-tab';
        break;
      case 'research':
        tabId = 'research-tab';
        break;
      case 'reports':
        tabId = 'reports-tab';
        break;
      case 'geography':
        tabId = 'geography-tab';
        break;
      case 'deprivation':
        tabId = 'deprivation-tab';
        break;
      case 'population':
        tabId = 'population-tab';
        break;
      case 'intervention':
        tabId = 'intervention-tab';
        break;
      case 'specify':
        tabId = 'specify-tab';
        break;
      case 'scenarios':
        tabId = 'scenarios-tab';
        break;
      case 'obesity risk':
        tabId = 'ObesityRisk-tab';
        break;
      case 'northern trust':
        tabId = 'NorthernTrust-tab';
        break;
      case 'lifestyle':
        tabId = 'lifestyle-tab';
        break;
      case 'society':
        tabId = 'society-tab';
        break;
      default:
        tabId = 'dashboard-tab';
    }

    $('#' + tabId).addClass('active show')

    // Re-initialize packery if dashboard tab is shown
    if (tabId === 'dashboard-tab') {
      setTimeout(function() {
        $('.grid').packery();
      }, 100);
    }

    // Initialize pivot module if reports tab is shown
    if (tabId === 'reports-tab') {
      setTimeout(function() {
        // Trigger pivot module column update
        if (window.Shiny && window.Shiny.setInputValue) {
          window.Shiny.setInputValue('pivot_reports_tab_shown', Math.random());
        }

        // Re-trigger any drag-drop initialization if needed
        if (typeof window.setupDropzone === 'function') {
          console.log('Re-initializing pivot drag-drop zones');
          window.setupDropzone('#column-pool');
          window.setupDropzoneCat('#groups-drop');
          window.setupDropzoneCat('#wide-by-drop');
          window.setupDropzone('#values-drop');
          window.setupDropzoneValueFunc('#value-func-drop');
        }
      }, 200);
    }
  });

  // Initialize Bootstrap Scrollspy
  var scrollspyEl = document.querySelector('[data-bs-spy="scroll"]');
  if (scrollspyEl) {
    var scrollspy = new bootstrap.ScrollSpy(scrollspyEl, {
      target: '#top-nav-content',
      offset: 80
    });
  }

});
