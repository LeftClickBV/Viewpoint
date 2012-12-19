=begin
  This file is part of Viewpoint; the Ruby library for Microsoft Exchange Web Services.

  Copyright © 2011 Dan Wanek <dan.wanek@gmail.com>

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
=end

module Viewpoint::EWS::Types
  class FileAttachment < Attachment

    attr_reader :file_name, :content

    # @param [Hash] attachment The attachment ews_item
    def initialize(item, attachment)
      @item = item
      super(item.ews, attachment)
    end

    # Save this FileAttachment object to a file.  By default it saves
    # it to the original file's name in the current working directory.
    # @param [String,nil] base_dir the directory to save the file to.  Pass nil if you
    #   do not want to specify a directory or you are passing a full path name to file_name
    # @param [String] file_name The name of the file to save the content to.
    #   Leave this blank to use the default attachment name.
    def save_to_file(base_dir = nil, file_name = @file_name)
      base_dir << '/' unless(base_dir.nil? or base_dir.end_with?('/'))
      File.open("#{base_dir}#{file_name}", 'w+') do |f|
        f.write(Base64.decode64(@content))
      end
      true
    end

  end
end

