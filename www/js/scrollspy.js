document.addEventListener('shown.bs.tab', function (event) {
  const scrollSpy = bootstrap.ScrollSpy.getInstance(document.body);
  if (scrollSpy) {
    // scrollSpy.refresh();
  } else {
    console.log('1');
    new bootstrap.ScrollSpy(document.body, {
      target: '#scrollspy-nav',
      offset: 0
    });
  }
});

// Re-initialize ScrollSpy every time a tab is shown
document.addEventListener('DOMContentLoaded', function () {
  const scrollSpy = bootstrap.ScrollSpy.getInstance(document.body);
  if (scrollSpy) {
    // scrollSpy.refresh();
  } else {
    console.log('1');
    new bootstrap.ScrollSpy(document.body, {
      target: '#scrollspy-nav',
      offset: 0
    });
  }
});
