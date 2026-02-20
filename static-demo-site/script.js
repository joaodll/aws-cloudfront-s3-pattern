document.addEventListener('DOMContentLoaded', function(){
  document.getElementById('shop-btn').addEventListener('click', function(){
    document.querySelector('#products').scrollIntoView({behavior:'smooth'});
  });

  document.getElementById('coupon-btn').addEventListener('click', function(){
    const code = 'ACME-20';
    navigator.clipboard?.writeText(code).then(function(){
      alert('Coupon code copied: ' + code + '\nUse at checkout (demo only).');
    }, function(){
      alert('Coupon: ' + code);
    });
  });

  document.querySelectorAll('.order').forEach(function(btn){
    btn.addEventListener('click', function(){
      const p = btn.getAttribute('data-product') || 'ACME Item';
      alert('Thanks for ordering "' + p + '"!\n(But this is a demo — no product will actually be delivered.)');
    });
  });
});
