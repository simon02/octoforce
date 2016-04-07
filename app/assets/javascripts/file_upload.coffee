$ ->
  node = $('<div>').addClass('preview')
  progressBar = $('<div>')
    .addClass('overlay')
    .prepend(
      $('<div>')
      .attr('id','#progress')
      .addClass('progress')
      .prepend(
        $('<div>')
        .addClass("progress-bar progress-bar-success")
      )
    )
  closeButton = $('<i>')
    .addClass('fa fa-close close-button')
  $('.jquery-upload-form').each ->
    assets = $(@).find('.assets')
    asset_id_field = $(@).find('input[name="post[asset_id]"]')
    submit_button = $(@).find('input[type="submit"]')
    $(@).find('.fileinput-button input[type="file"]').fileupload(
      url: "/files",
      dataType: 'json',
      formData: {_method: 'POST'},
      type: 'POST',
      autoUpload: true,
      acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
      maxFileSize: 2000000,
      # Enable image resizing, except for Android and Opera,
      # which actually support image resizing, but fail to
      # send Blob objects via XHR requests:
      disableImageResize: /Android(?!.*Chrome)|Opera/.test(window.navigator.userAgent),
      previewMaxWidth: 120,
      previewMaxHeight: 120,
      previewCrop: true,
      previewCanvas: false
    ).on('fileuploadadd', (e, data) ->
      # data.context = $('<div/>').appendTo('#assets');
      # $.each(data.files, (index, file) ->
      #  node = $('<p/>')
      #  node.appendTo(data.context)
      #)
      data.context = $('<div>').addClass('preview')
      data.context
        .append(closeButton.clone().click ->
          assets.empty()
          asset_id_field.val('').trigger('change')
        )
        .append(progressBar.clone())
      assets.html data.context
      $(@).parent().find('.text').text('replace file')
      submit_button.prop('disabled',true);
    ).on('fileuploadprocessalways', (e, data) ->
      index = data.index
      file = data.files[index]
      node = data.context
      if file.preview
        node
          .append(file.preview)
      if file.error
        node
          .prepend('<br>')
          .prepend($('<span class="text-danger"/>').text(file.error))
    ).on('fileuploadprogress', (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10);
      data.context.find('.progress-bar').css('width', progress + '%')
    ).on('fileuploaddone', (e, data) ->
      data.context.addClass('done')
      submit_button.prop('disabled',false);
      asset_id = data.result.id
      if asset_id
        asset_id_field.val(asset_id).trigger('change')
    )
