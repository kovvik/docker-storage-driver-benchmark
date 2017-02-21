FROM ruby:2.3
COPY ./create_files.sh /create_files.sh
COPY ./benchmark.rb /benchmark.rb
RUN /create_files.sh
ENTRYPOINT /benchmark.rb
