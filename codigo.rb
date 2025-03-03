# Añadimos la librería que utilizaremos en el código
require 'ruby-nfc'

# Una nueva clase Rfid
class Rfid
  
  # Declaramos un método que se encarga de leer el UID de las tarjetas NFC
  def read_uid
    
    # Obtener los lectores NFC disponibles y devuelve nil si no hay lectores disponibles
    readers = NFC::Reader.all
    return nil if readers.empty?

    # Iniciar la detección de tarjetas de 3 diferentes tipos de NFC
    readers[0].poll(IsoDep::Tag, Mifare::Classic::Tag, Mifare::Ultralight::Tag) do |tag|
      
      # Determinar el tipo de tarjeta y extraer su UID
      begin
        case tag
        when Mifare::Classic::Tag, Mifare::Ultralight::Tag
          return tag.uid_hex.upcase
        when IsoDep::Tag
          return tag.uid.unpack1('H*').upcase
        end

      # Detectar si hay algún error
      rescue StandardError => e
        puts "Error al leer la tarjeta: #{e.message}"
        return nil
      end
    end
    nil
  end
end

# Ejecutar el código si es el archivo principal
if __FILE__ == $0
  
  # Crear un objeto Rfid
  rf = Rfid.new
  
  # Mostrar mensaje de espera
  puts "Esperando para leer la tarjeta NFC..."
  
  # Método para obtener el UID
  uid = rf.read_uid
  
  # Mostrar el resultado
  if uid
    puts "UID de la tarjeta: #{uid}"
  else
    puts "No se pudo leer la tarjeta."
  end
end
