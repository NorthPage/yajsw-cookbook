# yajsw-cookbook

Installs and manages 'Yet Another Java Service Wrapper'.

Read more about [YAJSW](http://yajsw.sourceforge.net/)

## Supported Platforms

* Ubuntu 14.x
* Centos 6.x, 7.x

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>node['yajsw']['url']</tt></td>
    <td>String</td>
    <td>Where to download YAJSW</td>
    <td><tt>http://softlayer-dal.dl.sourceforge.net/project/yajsw/yajsw/yajsw-stable-11.11/yajsw-stable-11.11.zip</tt></td>
  </tr>
  <tr>
    <td><tt>node['yajsw']['file']</tt></td>
    <td>String</td>
    <td>The name of the downloaded archive.</td>
    <td><tt>yajsw-stable-11.11.zip</tt></td>
  </tr>
  <tr>
    <td><tt>node['yajsw']['checksum']</tt></td>
    <td>String</td>
    <td>MD5 checksum of the downloaded archive.</td>
    <td><tt>3b4fff8475e48cb001c38a42c27c953b</tt></td>
  </tr>
    <tr>
      <td><tt>node['yajsw']['dirname']</tt></td>
      <td>String</td>
      <td>Name of the extracted directory.</td>
      <td><tt>yajsw-stable-11.11</tt></td>
    </tr>
  <tr>
    <td><tt>node['yajsw']['basedir']</tt></td>
    <td>String</td>
    <td>The base directory to use for the YAJSW installation.</td>
    <td><tt>/usr/local</tt></td>
  </tr>
  <tr>
    <td><tt>node['yajsw']['appsdir']</tt></td>
    <td>String</td>
    <td>The directory to use for YAJSW managed application.</td>
    <td><tt>/usr/local/yajsw_apps</tt></td>
  </tr>
  <tr>
    <td><tt>node['yajsw']['piddir']</tt></td>
    <td>String</td>
    <td>The directory to use for YAJSW application pids.</td>
    <td><tt>/var/run</tt></td>
  </tr>
  <tr>
    <td><tt>node['yajsw']['user']</tt></td>
    <td>String</td>
    <td>The owner of the YAJSW installation.</td>
    <td><tt>root</tt></td>
  </tr>
  <tr>
    <td><tt>node['yajsw']['use_data_bag']</tt></td>
    <td>Boolean</td>
    <td>Collect application info from a data bag instead of node attributes.</td>
    <td><tt>false</tt></td>
  </tr>
   <tr>
     <td><tt>node['yajsw']['data_bag_name']</tt></td>
     <td>String</td>
     <td>Name of the data bag to collect application information.</td>
     <td><tt>yajsw</tt></td>
   </tr>
   <tr>
     <td><tt>node['yajsw']['use_env_data_bags']</tt></td>
     <td>Boolean</td>
     <td>Appends the environment to the end of the data bag name. (ie.  'yajsw' becomes 'yajsw_prod')</td>
     <td><tt>true</tt></td>
   </tr>
    <tr>
      <td><tt>node['yajsw']['apps']</tt></td>
      <td>Array</td>
      <td>The array of application configurations (if not using data bags).</td>
      <td><pre>
    [{
      'name' => 'myapp',
      'user' => 'yajsw',
      'initmemory' => 64,
      'maxmemory' => 256,
      'mainclass' => 'com.company.myapp',
      'jar' => 'lib/com.company.myapp.jar',
      'classpath' => [],
      'additional' => ['-server', '-Dfile.encoding=UTF-8'],
      'parameters' => ['-a', '-b', 'foobar', '-c'],
      'logfile' => {
        'maxfiles' => 10,
        'maxsize' => '10m',
        'loglevel' => 'INFO'
      }
    }]
      </pre></td>
    </tr>
</table>

## Usage

### yajsw::default

Include `yajsw` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[yajsw::default]"
  ]
}
```

The default implementation will install yajsw in `/usr/local/` and create an application dir in `/usr/local/yajsw_apps`.


### LWRP

If you prefer, you can use the YAJSW recipes individually, and configure your application with the included LWRP.

*Note:* The LWRP will not install yajsw, use `recipe[yajsw::package]` for that.

### yajsw_app

yajsw_app will configure an instance of YAJSW

```ruby
  logfile = { 'maxfiles' => 10, 'maxsize' => '10m', 'loglevel' => 'INFO' }
  yajsw_app 'myapp' do
    user 'yajsw'
    mainclass 'com.company.myapp'
    jar 'lib/com.company.myapp.jar'
    classpath []
    additional ['-server', '-Dfile.encoding=UTF-8']
    parameters ['-a', '-b', 'foobar', '-c']
    initmemory 16
    maxmemory 256
    logfile logfile
    create_user true
    action [:create, :update]
  end
```

### Data Bags

TODO: implement this functionality

If `node['yajsw']['use_data_bag']` is `true`,  `yajsw` will require a data bag in the following format:

## License and Authors

Author:: E Camden Fisher (<camden@northpage.com>)
Copyright (C) 2015 NorthPage

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
