Pod::Spec.new do |s|
  s.name         = "objc-zmq"
  s.version      = "0.1.0"
  s.summary      = "Objective-C binding for ZeroMQ"
  s.description  = <<-DESC
    Bundled with ZeroMQ 4.0.3 library.
    
    This is an Objective-C version of the reference ZeroMQ object-oriented C API. It follows the guidelines laid out by the official "Guidelines for ZeroMQ bindings".
    DESC
  s.homepage     = "https://github.com/neoneye/objc-zmq"
  s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license      = 'MIT'
  s.author       = { "Simon Strandgaard" => "simon@opcoders.com" }
  s.source       = { :git => "https://github.com/neoneye/objc-zmq.git", :tag => s.version.to_s }
  s.platform     = :osx, '10.9'
  s.osx.deployment_target = '10.9'
  s.requires_arc = true
  s.source_files = 'Classes/cppzmq/*.hpp', 'Classes/objc-zmq/*.{h,m}', 'Classes/zeromq/*.h'
  s.public_header_files = 'Classes/**/*.{h,hpp}'
  s.vendored_libraries = 'Library/zeromq-4.0.3/static/libzmq.a'
  s.libraries = 'c++'
end
