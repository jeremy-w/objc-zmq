Pod::Spec.new do |s|
  s.name         = "objc-zmq"
  s.version      = "0.1.2"
  s.summary      = "Objective-C binding for ZeroMQ"
  s.description  = <<-DESC
    Bundled with ZeroMQ 4.0.5 library.
    
    This is an Objective-C version of the reference ZeroMQ object-oriented C API. It follows the guidelines laid out by the official "Guidelines for ZeroMQ bindings".
    DESC
  s.homepage     = "https://github.com/jeremy-w/objc-zmq"
  s.license      = 'MIT'
  s.author       = { "Simon Strandgaard" => "simon@opcoders.com" }
  s.source       = { :git => "https://github.com/jeremy-w/objc-zmq.git", :tag => s.version.to_s }
  s.platform     = :osx, '10.10'
  s.platform     = :ios, '7.0'
  s.osx.deployment_target = '10.10'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.source_files = 'Classes/cppzmq/*.hpp', 'Classes/objc-zmq/*.{h,m}', 'Classes/zeromq/*.h'
  s.public_header_files = 'Classes/**/*.{h,hpp}'
  s.vendored_libraries = 'Library/zeromq-4.0.5/static/libzmq.a'
  s.libraries = 'c++'
end
