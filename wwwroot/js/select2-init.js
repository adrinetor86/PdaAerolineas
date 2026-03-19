(function () {
  'use strict';

  if (!window.jQuery || !jQuery.fn || !jQuery.fn.select2) return;

  const DEFAULT_CONFIG = {
    width: '100%',
    dropdownCssClass: 'select2-dropdown-custom'
  };

  function applySelect2Styles() {
    const $ = window.jQuery;

    $('.select2-container--default .select2-selection--single').css({
      'height': '48px',
      'border-radius': '12px',
      'border': '1px solid #e5e7eb',
      'background': '#f9fafb',
      'padding': '0 16px',
      'font-size': '14px',
      'font-weight': '600',
      'display': 'flex',
      'align-items': 'center',
      'transition': 'all 0.15s ease'
    });

    $('.select2-container--default .select2-selection--single .select2-selection__rendered').css({
      'line-height': '48px',
      'padding-left': '0',
      'color': '#374151'
    });

    $('.select2-container--default .select2-selection--single .select2-selection__arrow').css({
      'height': '48px',
      'right': '12px'
    });
  }

  function placeholderFromSelect($select) {
    // Si hay data-placeholder, usamos eso.
    const dp = $select.data('placeholder');
    if (typeof dp === 'string' && dp.trim() !== '') return dp;

    // Si existe option vacía/placeholder, la usamos.
    const first = $select.find('option').first();
    if (first && (first.val() === '' || first.prop('disabled'))) {
      const txt = (first.text() || '').trim();
      if (txt) return txt;
    }

    return 'Buscar...';
  }

  function enableSelect2OnSelect($select) {
    const $ = window.jQuery;

    // No convertir selects de tamaño/paginación, ni selects múltiples, ni selects marcados como no-select2.
    if ($select.is('[data-no-select2]')) return;
    if ($select.is('[multiple]')) return;

    const nameOrId = ($select.attr('name') || $select.attr('id') || '').toLowerCase();
    if (nameOrId.includes('numfilas') || nameOrId.includes('page') || nameOrId.includes('pagina')) return;

    // Si ya es select2, no reinicializamos.
    if ($select.data('select2')) return;

    const allowClear = $select.attr('required') ? false : true;

    $select.select2({
      ...DEFAULT_CONFIG,
      placeholder: placeholderFromSelect($select),
      allowClear
    });
  }

  function initSelect2(root) {
    const $ = window.jQuery;
    const $root = root ? $(root) : $(document);

    $root.find('select[data-enhance="select2"], select.select2, select[data-select2="true"]').each(function () {
      enableSelect2OnSelect($(this));
    });

    applySelect2Styles();
  }

  // Exponemos helpers para casos dinámicos (partials, modales, reemplazo AJAX, etc.)
  window.PDASelect2 = {
    init: initSelect2,
    applyStyles: applySelect2Styles
  };

  document.addEventListener('DOMContentLoaded', function () {
    initSelect2(document);
  });
})();

