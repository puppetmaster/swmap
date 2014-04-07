require 'rasem'

class SwPort
    def initialize(id, name)
        @id = id
        @name = name
        @vlan = "1"
        @vlan_mode = "untagged"
        @link_port = "0"
    end

    def set_vlan(vlan)
        @name = vlan 
    end

    def set_vlan_mode(mode)
        @vlan_mode = mode
    end

    def set_link_port(port)
        @link_port = port 
    end

    def show()
        puts("[#{@id} - #{@name}] ")
    end
end


class Switch
    attr_reader :ports
    def initialize(id, name, nb_ports, slaves=[])
        @id = id 
        @name = name 
        @ports = []
        nb_ports.times do |port| 
            if port == 0
                next
            end
            port_id = "#{id}/g#{port}"
            @ports.push(SwPort.new(port_id,port_id))
        end
        @slaves = slaves 
    end

    def show()
        puts("Switch ID : #{@id}")
        puts("Switch NAME : #{@name}")
        puts("Switch Ports :")
        for port in @ports
            port.show 
        end 
    end

    def draw(image, x, y)
        port_size = 80
        margin = 2
        width = (@ports.size + margin) * port_size
        height = port_size * 2 + margin
        image.rectangle(x, y, width, height, :stroke_width=>2, :fill=>"blue")
        port_x = x
        port_y = y
        @ports.each do |prt|
            image.rectangle(port_x, port_y, port_size, port_size, :fill=>"white")
            port_x = port_x + 2 + port_size
        end 
    end
end

class SwStack

    def initialize(id, name, sws)
        @id = id
        @name = name
        @sws = sws 
    end 

    def show
        puts("Stack #{@id} #{@name}")
        @sws.each do |sw|
            sw.show
        end
    end 

    def draw(image)
        x = 10
        y = 10 
        @sws.each do |sw|
            sw.draw(image, x, y)
            y += 150 + 5
        end 
    end
end


=begin
img = Rasem::SVGImage.new(100,100) do
      circle 20, 20, 5
      circle 50, 50, 5
      line 20, 20, 50, 50
end
=end

image = Rasem::SVGImage.new(4096, 1024)
sw1 = Switch.new("1","SwB1a",24, true)
sw2 = Switch.new("2","SwB1b",24, true)
stack = SwStack.new("1","SwB1",[sw1, sw2])
stack.draw(image)

image.close
File.open("test.svg", "w") do |f|
    f << image.output
end
