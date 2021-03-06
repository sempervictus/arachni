=begin
                  Arachni
  Copyright (c) 2010-2012 Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>

  This is free software; you can copy and distribute and modify
  this program under the term of the GPL v2.0 License
  (See LICENSE file for details)

=end

require 'openssl'
require "base64"

#
# Simple hybrid crypto class using RSA for public key encryption and AES with CBC
# for bulk data encryption/decryption.
#
# RSA is used to encrypt the AES primitives which are used to encrypt the plaintext.
#
# @author: Tasos "Zapotek" Laskos
#                                      <tasos.laskos@gmail.com>
#                                      <zapotek@segfault.gr>
# @version: 0.1
#
class RSA_AES_CBC

    #
    # If only encryption is required the private key parameter can be omitted.
    #
    # @param  [String]  public_pem   location of the Public key in PEM format
    # @param  [String]  private_pem  location of the Private key in PEM format
    #
    def initialize( public_pem, private_pem = nil )
        @public_pem  = public_pem
        @private_pem = private_pem
    end

    #
    # Encrypts data and returns a Base64 representation of the ciphertext
    # and AES CBC primitives encrypted using the public key.
    #
    # @param  [String]  data
    #
    # @return  [String]   Base64 representation of the ciphertext
    #                       and AES CBC primitives encrypted using the public key.
    #
    def encrypt( data )
        rsa = OpenSSL::PKey::RSA.new( File.read( @public_pem ) )

        # encrypt with 256 bit AES with CBC
        aes = OpenSSL::Cipher::Cipher.new( 'aes-256-cbc' )
        aes.encrypt

        # use random key and IV
        aes.key = key = aes.random_key
        aes.iv  = iv  = aes.random_iv

        # this will hold all primitives and ciphertext
        primitives = {}

        primitives['ciphertext'] = aes.update( data )
        primitives['ciphertext'] << aes.final

        primitives['key'] = rsa.public_encrypt( key )
        primitives['iv']  = rsa.public_encrypt( iv )

        # serialize everything and base64 encode it
        Base64.encode64( primitives.to_yaml )
    end

    #
    # Decrypts data.
    #
    # @param  [String]  data
    #
    # @return  [String]   plaintext
    #
    def decrypt( data )
        rsa = OpenSSL::PKey::RSA.new( File.read( @private_pem ) )

        # decrypt with 256 bit AES with CBC
        aes = OpenSSL::Cipher::Cipher.new( 'aes-256-cbc' )
        aes.decrypt

        # unencode and unserialize to get the primitives and ciphertext
        primitives = YAML::load( Base64.decode64( data ) )

        aes.key = rsa.private_decrypt( primitives['key'] )
        aes.iv  = rsa.private_decrypt( primitives['iv'] )

        plaintext = aes.update( primitives['ciphertext'] )
        plaintext << aes.final

        return plaintext
    end

end
