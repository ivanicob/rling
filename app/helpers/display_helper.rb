module DisplayHelper
 def check_component_type(form_component,form_submission)
   unless form_submission.nil?
   form_data=FormData.find_by_form_submission_id_and_form_component_id(form_submission.id,form_component.id)
  
   value = (form_submission.id.nil? ? form_component.default_value : ( form_data.data_value unless form_data.nil? ) )
   else
    value=form_component.default_value
   end
   case form_component.component_type
    when "Textfield"
      return text_field_tag("form_field[#{form_component.component_name}]",value)
    when "Textarea"
      return text_area_tag("form_field[#{form_component.component_name}]",value)
   when "Label"
      return label_tag("form_field[#{form_component.component_name}]",value)
    when "Dropdown"
      dropdown = form_component.component_values.split(',')
      return select_tag("form_field[#{form_component.component_name}]",options_for_select(dropdown,:selected=>value))
    when "Checkbox"
      return check_box_tag("form_field[#{form_component.component_name}]","1",("1"==value))
    when "Radiobutton"
      output = ""
      form_component.component_values.split(',').each do |radiobuttonvalue|
        output << radio_button_tag("form_field[#{form_component.component_name}]",radiobuttonvalue,(radiobuttonvalue == value))+radiobuttonvalue
      end
      return raw(output)
    when "File"
      display_file = ""
      unless form_submission.id.nil?
      unless value.blank?
       asset = Asset.find(value)
     
       display_file = link_to("#{asset.upload_file_name}", asset.upload.url,:target=>"_blank")+" "+link_to("[X]",delete_asset_object_form_form_submission_path(form_data.form_submission.object_form,form_data.id))
       end
       return file_field_tag("form_field[#{form_component.component_name}]") + display_file
      else
        return file_field_tag("form_field[#{form_component.component_name}]")
      end


	  end
  end

 

end
