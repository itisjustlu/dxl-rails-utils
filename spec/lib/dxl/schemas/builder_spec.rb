# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::DXL::Schemas::Builder do
  describe '.test1' do
    subject { described_class.new(serializer, klass).call }

    let(:serializer) { QuestionSerializer }
    let(:klass) { Question }

    it 'returns the expected schema' do
      hash = {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string, default: '0' },
              type: { type: :string, default: 'question' },
              attributes: {
                type: :object,
                properties: {
                  id: { type: :integer, nullable: true },
                  title: { type: :string, nullable: true },
                  data: {
                    type: :object,
                    nullable: true,
                    properties: {
                      channel_id: { type: :string, nullable: true },
                      channel_name: { type: :string, nullable: true },
                      organization_data: {
                        type: :array,
                        items: {
                          type: :object,
                          nullable: true,
                          properties: {
                            report_id: { type: :string, nullable: true },
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      expect(subject).to eq(hash)
    end
  end

  describe '.test2' do
    subject { described_class.new(serializer, klass).call }

    let(:serializer) { OrganizationSerializer }
    let(:klass) { Organization }

    it 'returns the expected schema' do
      expect(subject).to eq({
                              type: :object,
                              properties: {
                                data: {
                                  type: :object,
                                  properties: {
                                    id: { type: :string, default: '0' },
                                    type: { type: :string, default: 'organization' },
                                    attributes: {
                                      type: :object,
                                      properties: {
                                        id: { type: :integer, nullable: true },
                                        data: {
                                          type: :array,
                                          items: {
                                            type: :object,
                                            nullable: true,
                                            properties: {
                                              report_id: { type: :string, nullable: true },
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            })
    end
  end

  describe '.test3' do
    subject { described_class.new(serializer, klass).call }

    let(:serializer) { OrganizationHasManySerializer }
    let(:klass) { Organization }

    it 'returns the expected schema' do
      hash = {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string, default: '0' },
              type: { type: :string, default: 'organization' },
              attributes: {
                type: :object,
                properties: {
                  id: { type: :integer, nullable: true },
                }
              },
              relationships: {
                type: :object,
                properties: {
                  questions: {
                    nullable: true,
                    type: :object,
                    properties: {
                      data: {
                        type: :array,
                        nullable: true,
                        items: {
                          nullable: true,
                          type: :object,
                          properties: {
                            id: { type: :string, default: '0' },
                            type: { type: :string, default: :questions },
                          },
                        }
                      }
                    },
                  }
                }
              }
            }
          },
        }
      }

      expect(subject).to eq(hash)
    end

    context 'when included' do
      subject { described_class.new(serializer, klass, included: [:questions]).call }

      it 'returns the expected schema' do
        hash = {
          type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :string, default: '0' },
                type: { type: :string, default: 'organization' },
                attributes: {
                  type: :object,
                  properties: {
                    id: { type: :integer, nullable: true },
                  }
                },
                relationships: {
                  type: :object,
                  properties: {
                    questions: {
                      nullable: true,
                      type: :object,
                      properties: {
                        data: {
                          type: :array,
                          nullable: true,
                          items: {
                            nullable: true,
                            type: :object,
                            properties: {
                              id: { type: :string, default: '0' },
                              type: { type: :string, default: :questions },
                            },
                          }
                        }
                      },
                    }
                  }
                }
              }
            },
            included: {
              type: :array,
              items: {
                anyOf: [
                  {
                    type: :object,
                    properties: {
                      id: { type: :string, default: '0' },
                      type: { type: :string, default: 'question' },
                      attributes: {
                        type: :object,
                        properties: {
                          id: { type: :integer, nullable: true },
                          title: { type: :string, nullable: true },
                          data: {
                            type: :object,
                            nullable: true,
                            properties: {
                              channel_id: { type: :string, nullable: true },
                              channel_name: { type: :string, nullable: true },
                              organization_data: {
                                type: :array,
                                items: {
                                  type: :object,
                                  nullable: true,
                                  properties: {
                                    report_id: { type: :string, nullable: true },
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                ]
              }
            }
          }
        }

        expect(subject).to eq(hash)
      end
    end
  end

  describe '.test4' do
    subject { described_class.new(serializer, klass).call }

    let(:serializer) { OrganizationHasOneSerializer }
    let(:klass) { Organization }


    it 'returns the expected schema' do
      hash = {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string, default: '0' },
              type: { type: :string, default: 'organization' },
              attributes: {
                type: :object,
                properties: {
                  id: { type: :integer, nullable: true },
                }
              },
              relationships: {
                type: :object,
                properties: {
                  question: {
                    type: :object,
                    nullable: true,
                    properties: {
                      data: {
                        nullable: true,
                        type: :object,
                        properties: {
                          id: { type: :string, default: '0' },
                          type: { type: :string, default: :question },
                        },
                      }
                    },
                  }
                }
              }
            }
          },
        }
      }

      expect(subject).to eq(hash)
    end

    context 'when included' do
      subject { described_class.new(serializer, klass, included: [:question]).call }

      it 'returns the expected schema' do
        hash = {
          type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :string, default: '0' },
                type: { type: :string, default: 'organization' },
                attributes: {
                  type: :object,
                  properties: {
                    id: { type: :integer, nullable: true },
                  }
                },
                relationships: {
                  type: :object,
                  properties: {
                    question: {
                      nullable: true,
                      type: :object,
                      properties: {
                        data: {
                          nullable: true,
                          type: :object,
                          properties: {
                            id: { type: :string, default: '0' },
                            type: { type: :string, default: :question },
                          },
                        }
                      },
                    }
                  }
                }
              }
            },
            included: {
              type: :array,
              items: {
                anyOf: [
                  {
                    type: :object,
                    properties: {
                      id: { type: :string, default: '0' },
                      type: { type: :string, default: 'question' },
                      attributes: {
                        type: :object,
                        properties: {
                          id: { type: :integer, nullable: true },
                          title: { type: :string, nullable: true },
                          data: {
                            type: :object,
                            nullable: true,
                            properties: {
                              channel_id: { type: :string, nullable: true },
                              channel_name: { type: :string, nullable: true },
                              organization_data: {
                                type: :array,
                                items: {
                                  type: :object,
                                  nullable: true,
                                  properties: {
                                    report_id: { type: :string, nullable: true },
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                ]
              }
            }
          }
        }

        expect(subject).to eq(hash)
      end
    end
  end

  describe '.test5' do
    subject { described_class.new(serializer, klass).call }

    let(:serializer) { OrganizationHasManyDifferentKeySerializer }
    let(:klass) { Organization }


    it 'returns the expected schema' do
      hash = {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string, default: '0' },
              type: { type: :string, default: 'organization' },
              attributes: {
                type: :object,
                properties: {
                  id: { type: :integer, nullable: true },
                }
              },
              relationships: {
                type: :object,
                properties: {
                  answers: {
                    type: :object,
                    nullable: true,
                    properties: {
                      data: {
                        type: :array,
                        nullable: true,
                        items: {
                          nullable: true,
                          type: :object,
                          properties: {
                            id: { type: :string, default: '0' },
                            type: { type: :string, default: :answers },
                          },
                        }
                      }
                    },
                  }
                }
              }
            }
          },
        }
      }

      expect(subject).to eq(hash)
    end

    context 'when included' do
      subject { described_class.new(serializer, klass, included: [:answers]).call }

      it 'returns the expected schema' do
        hash = {
          type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :string, default: '0' },
                type: { type: :string, default: 'organization' },
                attributes: {
                  type: :object,
                  properties: {
                    id: { type: :integer, nullable: true },
                  }
                },
                relationships: {
                  type: :object,
                  properties: {
                    answers: {
                      nullable: true,
                      type: :object,
                      properties: {
                        data: {
                          type: :array,
                          nullable: true,
                          items: {
                            nullable: true,
                            type: :object,
                            properties: {
                              id: { type: :string, default: '0' },
                              type: { type: :string, default: :answers },
                            },
                          }
                        }
                      },
                    }
                  }
                }
              }
            },
            included: {
              type: :array,
              items: {
                anyOf: [
                  {
                    type: :object,
                    properties: {
                      id: { type: :string, default: '0' },
                      type: { type: :string, default: 'question' },
                      attributes: {
                        type: :object,
                        properties: {
                          id: { type: :integer, nullable: true },
                          title: { type: :string, nullable: true },
                          data: {
                            type: :object,
                            nullable: true,
                            properties: {
                              channel_id: { type: :string, nullable: true },
                              channel_name: { type: :string, nullable: true },
                              organization_data: {
                                type: :array,
                                items: {
                                  type: :object,
                                  nullable: true,
                                  properties: {
                                    report_id: { type: :string, nullable: true },
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                ]
              }
            }
          }
        }

        expect(subject).to eq(hash)
      end
    end
  end

























end