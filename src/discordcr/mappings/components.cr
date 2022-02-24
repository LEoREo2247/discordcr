require "./converters"

module Discord
  enum ComponentType : UInt8
    ActionRow  = 1
    Button     = 2
    SelectMenu = 3
    TextInput  = 4
  end

  enum ButtonStyle : UInt8
    Primary   = 1
    Secondary = 2
    Success   = 3
    Danger    = 4
    Link      = 5
  end

  enum TextInputStyle : UInt8
    Short     = 1
    Paragraph = 2
  end

  abstract struct Component
    include JSON::Serializable

    use_json_discriminator "type", {
      ComponentType::ActionRow  => ActionRow,
      ComponentType::Button     => Button,
      ComponentType::SelectMenu => SelectMenu,
      ComponentType::TextInput  => TextInput,
    }

    @[JSON::Field(converter: Enum::ValueConverter(Discord::ComponentType))]
    property type : ComponentType
  end

  struct ActionRow < Component
    @type : ComponentType = ComponentType::ActionRow

    property components : Array(Button | SelectMenu | TextInput)

    def initialize(*components : Button | SelectMenu | TextInput)
      @components = [*components] of Button | SelectMenu | TextInput
    end
  end

  struct Button < Component
    @type : ComponentType = ComponentType::Button

    @[JSON::Field(converter: Enum::ValueConverter(Discord::ButtonStyle))]
    property style : ButtonStyle
    property label : String?
    property emoji : Emoji?
    property custom_id : String?
    property url : String?
    property disabled : Bool?

    def initialize(@style, @label = nil, @emoji = nil, @custom_id = nil, @url = nil, @disabled = nil)
    end
  end

  struct SelectMenu < Component
    @type : ComponentType = ComponentType::SelectMenu

    property custom_id : String
    property options : Array(SelectOption)
    property placeholder : String?
    property min_values : UInt8?
    property max_values : UInt8?
    property disabled : Bool?

    def initialize(@custom_id, @options, @placeholder = nil, @min_values = nil, @max_values = nil, @disabled = nil)
    end
  end

  struct TextInput < Component
    @type : ComponentType = ComponentType::TextInput

    property custom_id : String
    @[JSON::Field(converter: Enum::ValueConverter(Discord::TextInputStyle))]
    property style : TextInputStyle?
    property label : String?
    property min_length : UInt16?
    property max_length : UInt16?
    property required : Bool?
    property value : String?
    property placeholder : String?

    def initialize(@custom_id, @style, @label, @min_length = nil, @max_length = nil, @required = nil, @value = nil, @placeholder = nil)
    end
  end

  struct SelectOption
    include JSON::Serializable

    property label : String
    property value : String
    property description : String?
    property emoji : Emoji?
    property default : Bool?

    def initialize(@label, @value, @description = nil, @emoji = nil, @default = nil)
    end
  end
end
